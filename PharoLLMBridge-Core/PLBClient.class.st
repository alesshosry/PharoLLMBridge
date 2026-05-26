Class {
	#name : 'PLBClient',
	#superclass : 'Object',
	#category : 'PharoLLMBridge-Core',
	#package : 'PharoLLMBridge-Core'
}

{ #category : 'api' }
PLBClient >> send: aPLBRequest [

	self subclassResponsibility
]
