Class {
	#name : 'PLBOllamaClientTest',
	#superclass : 'TestCase',
	#instVars : [
		'client'
	],
	#category : 'PharoLLMBridge-Tests',
	#package : 'PharoLLMBridge-Tests'
}

{ #category : 'running' }
PLBOllamaClientTest >> setUp [  

	super setUp.
	client := PLBOllamaClient new 
]

{ #category : 'tests' }
PLBOllamaClientTest >> testExtractTextFromResponseReturnsResponseField [  

	| responseData |
	
	responseData := Dictionary new at: 'response' put: '{"names":["alerts"]}'; yourself.

	self assert: (client extractTextFromResponse: responseData) equals: '{"names":["alerts"]}' 
]

{ #category : 'tests' }
PLBOllamaClientTest >> testInitializeHasDefaultEndpointAndModel [  

	self assert: client endpoint equals: 'http://localhost:11434/api/generate'.
	self assert: client model isNotNil  
]

{ #category : 'tests' }
PLBOllamaClientTest >> testParseRawTextForJSONReturnsDictionary [  

	| request parsed |
	request := PLBRequest new expectedFormat: #json; yourself.
	parsed := client parseRawText: '{"names":["alerts"]}' for: request.

	self assert: (parsed at: 'names') equals: #('alerts') 
]

{ #category : 'tests' }
PLBOllamaClientTest >> testRequestBodyForIncludesModelPromptAndSystemPrompt [ 

	| request body |
	request := PLBRequest new
		prompt: 'prompt';
		metadata: (Dictionary new at: #systemPrompt put: 'system'; yourself);
		yourself.
	body := NeoJSONReader fromString: (client requestBodyFor: request).

	self assert: (body at: 'model') equals: client model.
	self assert: (body at: 'prompt') equals: 'prompt'.
	self assert: (body at: 'stream') equals: false.
	self assert: (body at: 'system') equals: 'system' 
]
