Class {
	#name : 'PLBRequest',
	#superclass : 'Object',
	#instVars : [
		'prompt',
		'expectedFormat',
		'parser',
		'timeout',
		'metadata'
	],
	#category : 'PharoLLMBridge-Core',
	#package : 'PharoLLMBridge-Core'
}

{ #category : 'accessing' }
PLBRequest >> expectedFormat [

	^ expectedFormat
]

{ #category : 'accessing' }
PLBRequest >> expectedFormat: anObject [

	expectedFormat := anObject
]

{ #category : 'initialization' }
PLBRequest >> initialize [

	super initialize.
	expectedFormat := #raw.
	metadata := Dictionary new
]

{ #category : 'accessing' }
PLBRequest >> metadata [

	^ metadata
]

{ #category : 'accessing' }
PLBRequest >> metadata: anObject [

	metadata := anObject
]

{ #category : 'accessing' }
PLBRequest >> parser [

	^ parser
]

{ #category : 'accessing' }
PLBRequest >> parser: anObject [

	parser := anObject
]

{ #category : 'accessing' }
PLBRequest >> prompt [

	^ prompt
]

{ #category : 'accessing' }
PLBRequest >> prompt: anObject [

	prompt := anObject
]

{ #category : 'accessing' }
PLBRequest >> timeout [

	^ timeout
]

{ #category : 'accessing' }
PLBRequest >> timeout: anObject [

	timeout := anObject
]
