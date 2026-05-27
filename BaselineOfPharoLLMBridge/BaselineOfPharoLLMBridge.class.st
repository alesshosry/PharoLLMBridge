Class {
	#name : 'BaselineOfPharoLLMBridge',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPharoLLMBridge',
	#package : 'BaselineOfPharoLLMBridge'
}

{ #category : 'accessing' }
BaselineOfPharoLLMBridge class >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : 'baselines' }
BaselineOfPharoLLMBridge >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec
			package: 'PharoLLMBridge-Core';
			package: 'PharoLLMBridge-Codex'
			with: [ spec requires: #( 'PharoLLMBridge-Core' ) ];
			package: 'PharoLLMBridge-OpenAI'
			with: [ spec requires: #( 'PharoLLMBridge-Core' ) ].

		spec
			group: 'default' with: #( 'Core' 'OpenAI' );
			group: 'Core' with: #( 'PharoLLMBridge-Core' );
			group: 'Codex' with: #( 'PharoLLMBridge-Codex' );
			group: 'OpenAI' with: #( 'PharoLLMBridge-OpenAI' ) ]
]
