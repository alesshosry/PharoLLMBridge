Class {
	#name : 'PLBCodexClient',
	#superclass : 'PLBClient',
	#instVars : [
		'command'
	],
	#category : 'PharoLLMBridge-Codex',
	#package : 'PharoLLMBridge-Codex'
}

{ #category : 'private' }
PLBCodexClient >> buildResponseFromRawText: aString [

	^ PLBResponse new
		  rawText: aString;
		  success: true;
		  parsedResult: aString;
		  yourself
]

{ #category : 'accessing' }
PLBCodexClient >> command [

	^ command
]

{ #category : 'accessing' }
PLBCodexClient >> command: aString [

	command := aString
]

{ #category : 'initialization' }
PLBCodexClient >> initialize [

	super initialize.
	command := 'codex'
]

{ #category : 'api' }
PLBCodexClient >> send: aPLBRequest [
	"This method will invoke the local Codex installation,
	send the prompt, and capture the result in a PLBResponse."

	self shouldBeImplemented
]
