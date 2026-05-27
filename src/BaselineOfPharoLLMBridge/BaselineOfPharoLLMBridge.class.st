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
		spec author: 'AlessHosry'.
		spec description: 'This project is a bridge beween Pharo and LLMs/AIAgents; So prompts can be sent from Pharo to LLMs/Agents and response returned to be displayed in Pharo. I created this project because I am trying a new approach for AdonisAngular using AI'.		
		self definePackages: spec.
		self defineGroups: spec ]
]

{ #category : 'baselines' }
BaselineOfPharoLLMBridge >> defineGroups: spec [

	spec
		group: 'default' with: #( 'Core' 'OpenAI' );
		group: 'Core' with: #( 'PharoLLMBridge-Core' );
		group: 'Codex' with: #( 'PharoLLMBridge-Codex' );
		group: 'OpenAI' with: #( 'PharoLLMBridge-OpenAI' );
		group: 'Ollama' with: #( 'PharoLLMBridge-Ollama' )
]

{ #category : 'baselines' }
BaselineOfPharoLLMBridge >> definePackages: spec [

	spec
		package: 'PharoLLMBridge-Core';
		package: 'PharoLLMBridge-Codex'
		with: [ spec requires: #( 'PharoLLMBridge-Core' ) ];
		package: 'PharoLLMBridge-OpenAI'
		with: [ spec requires: #( 'PharoLLMBridge-Core' ) ];
		package: 'PharoLLMBridge-Ollama'
		with: [ spec requires: #( 'PharoLLMBridge-Core' ) ]
]
