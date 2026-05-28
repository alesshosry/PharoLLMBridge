Class {
	#name : 'PLBCodexClientTest',
	#superclass : 'TestCase',
	#instVars : [
		'client'
	],
	#category : 'PharoLLMBridge-Tests',
	#package : 'PharoLLMBridge-Tests'
}

{ #category : 'running' }
PLBCodexClientTest >> setUp [  
	super setUp.
	client := PLBCodexClient new
]

{ #category : 'tests' }
PLBCodexClientTest >> testBuildResponseFromRawTextCreatesSuccessfulResponse [  

	| response |
	response := client buildResponseFromRawText: '{"names":["alerts"]}'.

	self assert: response success.
	self assert: response rawText equals: '{"names":["alerts"]}'.
	self assert: response parsedResult equals: '{"names":["alerts"]}' 
]

{ #category : 'tests' }
PLBCodexClientTest >> testCommandAccessorChangesCommand [  

	client command: '/usr/local/bin/codex'.

	self assert: client command equals: '/usr/local/bin/codex' 
]

{ #category : 'tests' }
PLBCodexClientTest >> testInitializeHasDefaultCommand [  

	self assert: client command equals: 'codex' 
]
