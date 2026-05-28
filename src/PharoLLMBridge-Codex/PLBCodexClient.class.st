"
`PharoLLMBridge-Codex` allows Pharo to send prompts to a local Codex installation and receive the result through the same request/response API used by the other backends.
It currently uses Codex through its local CLI in non-interactive mode.

Default configuration added in `PharoLLMBridge-Codex>>initialize:`
- command: codex
The client currently invokes Codex through codex exec.
Before using PharoLLMBridge-Codex, you need:
- Codex installed on your machine
- the Codex CLI available at the configured command path
If your Codex binary is installed in a different location, you can change the command in the client.

#### Example of usage:

```
prompt := 'Return only valid JSON object {""names"":[""alerts""]} and nothing else.'.
request := PLBRequest new
	prompt: prompt;
	expectedFormat: #json;
	yourself.
response := PLBCodexClient new send: request.
```
"
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
