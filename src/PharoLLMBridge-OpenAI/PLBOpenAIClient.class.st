Class {
	#name : 'PLBOpenAIClient',
	#superclass : 'PLBClient',
	#instVars : [
		'apiKey',
		'endpoint',
		'model'
	],
	#category : 'PharoLLMBridge-OpenAI',
	#package : 'PharoLLMBridge-OpenAI'
}

{ #category : 'accessing' }
PLBOpenAIClient >> apiKey [

	^ apiKey
]

{ #category : 'accessing' }
PLBOpenAIClient >> apiKey: aString [

	apiKey := aString
]

{ #category : 'accessing' }
PLBOpenAIClient >> endpoint [

	^ endpoint
]

{ #category : 'accessing' }
PLBOpenAIClient >> endpoint: aString [

	endpoint := aString
]

{ #category : 'private' }
PLBOpenAIClient >> extractTextFromResponse: responseData [

	| choices firstChoice message |
	choices := responseData at: 'choices' ifAbsent: [ ^ '' ].
	choices ifEmpty: [ ^ '' ].
	firstChoice := choices first.
	message := firstChoice at: 'message' ifAbsent: [ ^ '' ].
	^ message at: 'content' ifAbsent: [ '' ]
]

{ #category : 'initialization' }
PLBOpenAIClient >> initialize [

	super initialize. 
	apiKey := OSEnvironment current at: 'OPENAI_API_KEY' ifAbsent: [ '' ].
	endpoint := 'https://api.openai.com/v1/chat/completions'.
	model := 'gpt-5.4-mini'
]

{ #category : 'private' }
PLBOpenAIClient >> messagesFor: aPLBRequest [

	| messages systemPrompt |
	messages := OrderedCollection new.
	systemPrompt := aPLBRequest metadata
			                at: #systemPrompt
			                ifAbsent: [ nil ].
	systemPrompt ifNotNil: [
		messages add: (Dictionary new
				 at: 'role' put: 'system';
				 at: 'content' put: systemPrompt;
				 yourself) ].
	messages add: (Dictionary new
			 at: 'role' put: 'user';
			 at: 'content' put: aPLBRequest prompt;
			 yourself).
	^ messages
]

{ #category : 'accessing' }
PLBOpenAIClient >> model [

	^ model
]

{ #category : 'accessing' }
PLBOpenAIClient >> model: aString [

	model := aString
]

{ #category : 'private' }
PLBOpenAIClient >> parseRawText: aString for: aPLBRequest [

	aPLBRequest parser ifNotNil: [ ^ aPLBRequest parser value: aString ].
	aPLBRequest expectedFormat = #json ifTrue: [
		^ [ NeoJSONReader fromString: aString ]
			  on: Error
			  do: [ nil ] ].
	^ aString
]

{ #category : 'private' }
PLBOpenAIClient >> requestBodyFor: aPLBRequest [

	| payload |
	payload := Dictionary new.
	payload at: 'model' put: self model.
	payload at: 'messages' put: (self messagesFor: aPLBRequest).
	aPLBRequest expectedFormat = #json ifTrue: [
		payload at: 'response_format' put: (Dictionary new
				 at: 'type' put: 'json_object';
				 yourself) ].
	^ NeoJSONWriter toString: payload
]

{ #category : 'api' }
PLBOpenAIClient >> send: aPLBRequest [

	| client responseBody responseData rawText response |
	self apiKey ifEmpty: [ self error: 'OPENAI_API_KEY is not set.' ].

	client := ZnClient new.
	client
		url: self endpoint;
		beOneShot;
		headerAt: 'Authorization' put: 'Bearer ' , self apiKey.
	client entity: (ZnEntity
			 with: (self requestBodyFor: aPLBRequest)
			 type: ZnMimeType applicationJson).
	client post.

	responseBody := client response contents.
	responseData := NeoJSONReader fromString: responseBody.
	rawText := self extractTextFromResponse: responseData.

	response := PLBResponse new.
	response
		rawText: rawText;
		stderr: responseBody;
		exitCode: client response code;
		success: client response isSuccess.
	response parsedResult: (self parseRawText: rawText for: aPLBRequest).
	^ response
]
