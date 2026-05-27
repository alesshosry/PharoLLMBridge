Class {
	#name : 'PLBOllamaClient',
	#superclass : 'PLBClient',
	#instVars : [
		'endpoint',
		'model'
	],
	#category : 'PharoLLMBridge-Ollama',
	#package : 'PharoLLMBridge-Ollama'
}

{ #category : 'accessing' }
PLBOllamaClient >> endpoint [

	^ endpoint
]

{ #category : 'accessing' }
PLBOllamaClient >> endpoint: aString [

	endpoint := aString
]

{ #category : 'private' }
PLBOllamaClient >> extractTextFromResponse: responseData [

	^ responseData at: 'response' ifAbsent: [ '' ]
]

{ #category : 'initialization' }
PLBOllamaClient >> initialize [

	super initialize.
	endpoint := 'http://localhost:11434/api/generate'.
	"model := 'mistral'"
	"model := 'qwen2.5'"
	"model := 'mistral-nemo'"
	model := 'qwen3-coder:30b'.
]

{ #category : 'accessing' }
PLBOllamaClient >> model [

	^ model
]

{ #category : 'accessing' }
PLBOllamaClient >> model: aString [

	model := aString
]

{ #category : 'private' }
PLBOllamaClient >> parseRawText: aString for: aPLBRequest [

	aPLBRequest parser ifNotNil: [ ^ aPLBRequest parser value: aString ].
	aPLBRequest expectedFormat = #json ifTrue: [
		^ [ NeoJSONReader fromString: aString ]
			  on: Error
			  do: [ nil ] ].
	^ aString
]

{ #category : 'private' }
PLBOllamaClient >> requestBodyFor: aPLBRequest [

	| payload systemPrompt |
	payload := Dictionary new.
	payload at: 'model' put: self model.
	payload at: 'prompt' put: aPLBRequest prompt.
	payload at: 'stream' put: false.
	systemPrompt := aPLBRequest metadata
		                at: #systemPrompt
		                ifAbsent: [ nil ].
	systemPrompt ifNotNil: [ payload at: 'system' put: systemPrompt ].
	^ NeoJSONWriter toString: payload
]

{ #category : 'api' }
PLBOllamaClient >> send: aPLBRequest [

	| client responseBody responseData rawText response |
	client := ZnClient new.
	client
		url: self endpoint;
		beOneShot.
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
