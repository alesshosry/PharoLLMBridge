Class {
	#name : 'PLBOpenAIClientTest',
	#superclass : 'TestCase',
	#instVars : [
		'client'
	],
	#category : 'PharoLLMBridge-Tests',
	#package : 'PharoLLMBridge-Tests'
}

{ #category : 'running' }
PLBOpenAIClientTest >> setUp [  

	super setUp.
	client := PLBOpenAIClient new 
]

{ #category : 'tests' }
PLBOpenAIClientTest >> testExtractTextFromResponseReturnsMessageContent [ 

	| responseData |
	responseData := Dictionary new
		at: 'choices' put: { (Dictionary new
			at: 'message' put: (Dictionary new at: 'content' put: '{"names":["alerts"]}'; yourself);
			yourself) } asOrderedCollection;
		yourself.

	self assert: (client extractTextFromResponse: responseData) equals: '{"names":["alerts"]}' 
]

{ #category : 'tests' }
PLBOpenAIClientTest >> testMessagesForIncludesSystemPromptWhenPresent [  

	| request messages |
	request := PLBRequest new
		prompt: 'hello';
		metadata: (Dictionary new at: #systemPrompt put: 'system'; yourself);
		yourself.
	messages := client messagesFor: request.

	self assert: messages size equals: 2.
	self assert: (messages first at: 'role') equals: 'system'.
	self assert: (messages first at: 'content') equals: 'system'.
	self assert: (messages second at: 'role') equals: 'user'.
	self assert: (messages second at: 'content') equals: 'hello' 
]

{ #category : 'tests' }
PLBOpenAIClientTest >> testParseRawTextForJSONReturnsDictionary [ 

	| request parsed |
	request := PLBRequest new expectedFormat: #json; yourself.
	parsed := client parseRawText: '{"names":["alerts"]}' for: request.

	self assert: (parsed at: 'names') equals: #('alerts') 

]

{ #category : 'tests' }
PLBOpenAIClientTest >> testRequestBodyForJSONIncludesResponseFormat [  

	| request body |
	request := PLBRequest new
		prompt: 'prompt';
		expectedFormat: #json;
		yourself.
	body := NeoJSONReader fromString: (client requestBodyFor: request).

	self assert: (body at: 'model') equals: client model.
	self assert: ((body at: 'response_format') at: 'type') equals: 'json_object'.
	self assert: ((body at: 'messages') first at: 'content') equals: 'prompt' 
]
