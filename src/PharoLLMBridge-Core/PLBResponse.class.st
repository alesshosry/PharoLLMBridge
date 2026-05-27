Class {
	#name : 'PLBResponse',
	#superclass : 'Object',
	#instVars : [
		'rawText',
		'parsedResult',
		'success',
		'stderr',
		'exitCode',
		'metadata'
	],
	#category : 'PharoLLMBridge-Core',
	#package : 'PharoLLMBridge-Core'
}

{ #category : 'accessing' }
PLBResponse >> exitCode [

	^ exitCode
]

{ #category : 'accessing' }
PLBResponse >> exitCode: anObject [

	exitCode := anObject
]

{ #category : 'initialization' }
PLBResponse >> initialize [

	super initialize.
	rawText := ''.
	stderr := ''.
	success := false.
	metadata := Dictionary new
]

{ #category : 'accessing' }
PLBResponse >> metadata [

	^ metadata
]

{ #category : 'accessing' }
PLBResponse >> metadata: anObject [

	metadata := anObject
]

{ #category : 'accessing' }
PLBResponse >> parsedResult [

	^ parsedResult
]

{ #category : 'accessing' }
PLBResponse >> parsedResult: anObject [

	parsedResult := anObject
]

{ #category : 'accessing' }
PLBResponse >> rawText [

	^ rawText
]

{ #category : 'accessing' }
PLBResponse >> rawText: anObject [

	rawText := anObject
]

{ #category : 'accessing' }
PLBResponse >> stderr [

	^ stderr
]

{ #category : 'accessing' }
PLBResponse >> stderr: anObject [

	stderr := anObject
]

{ #category : 'accessing' }
PLBResponse >> success [

	^ success
]

{ #category : 'accessing' }
PLBResponse >> success: anObject [

	success := anObject
]
