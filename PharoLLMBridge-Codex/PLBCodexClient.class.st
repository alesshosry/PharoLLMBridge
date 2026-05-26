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
PLBCodexClient >> buildResponseFor: aPLBRequest exitCode: exitCode outputFile: outputFile stdoutFile: stdoutFile stderrFile: stderrFile [

	| response rawText stderrText |
	response := PLBResponse new.
	rawText := outputFile exists
		           ifTrue: [ outputFile contents ]
		           ifFalse: [
			           stdoutFile exists
				           ifTrue: [ stdoutFile contents ]
				           ifFalse: [ '' ] ].
	stderrText := stderrFile exists
		              ifTrue: [ stderrFile contents ]
		              ifFalse: [ '' ].

	response
		rawText: rawText;
		stderr: stderrText;
		exitCode: exitCode;
		success: (exitCode = 0 and: [ rawText isNotEmpty ]).

	response parsedResult: (self parseRawText: rawText for: aPLBRequest).
	^ response
]

{ #category : 'private' }
PLBCodexClient >> buildResponseFromRawText: aString [

	^ PLBResponse new
		  rawText: aString;
		  success: true;
		  parsedResult: aString;
		  yourself
]

{ #category : 'private' }
PLBCodexClient >> buildShellCommandFor: aPLBRequest promptFile: promptFile outputFile: outputFile stdoutFile: stdoutFile stderrFile: stderrFile [

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: self commandQuoted;
			  nextPutAll: ' exec --skip-git-repo-check --ephemeral -o ';
			  nextPutAll: outputFile pathString printString;
			  nextPutAll: ' - < ';
			  nextPutAll: promptFile pathString printString;
			  nextPutAll: ' > ';
			  nextPutAll: stdoutFile pathString printString;
			  nextPutAll: ' 2> ';
			  nextPutAll: stderrFile pathString printString ]
]

{ #category : 'accessing' }
PLBCodexClient >> command [

	^ command
]

{ #category : 'accessing' }
PLBCodexClient >> command: aString [

	command := aString
]

{ #category : 'private' }
PLBCodexClient >> commandQuoted [

	^ self command printString
]

{ #category : 'initialization' }
PLBCodexClient >> initialize [

	super initialize.
	command := '/opt/homebrew/bin/codex'
]

{ #category : 'private' }
PLBCodexClient >> jsonArraySchemaFile [

	| schemaFile |
	schemaFile := FileLocator temp / 'plb-codex-json-array-schema.json'.
	schemaFile exists ifFalse: [
		schemaFile writeStreamDo: [ :stream |
			stream nextPutAll: '{"type":"array","items":{}}' ] ].
	^ schemaFile
]

{ #category : 'private' }
PLBCodexClient >> jsonObjectSchemaFile [

	| schemaFile |
	schemaFile := FileLocator temp / 'plb-codex-json-object-schema.json'.
	schemaFile exists ifFalse: [
		schemaFile writeStreamDo: [ :stream |
			stream nextPutAll: '{"type":"object","additionalProperties":true}' ] ].
	^ schemaFile
]

{ #category : 'private' }
PLBCodexClient >> parseRawText: aString for: aPLBRequest [

	aPLBRequest parser ifNotNil: [ ^ aPLBRequest parser value: aString ].
	aPLBRequest expectedFormat = #json ifTrue: [
		^ [ NeoJSONReader fromString: aString ]
			  on: Error
			  do: [ nil ] ].
	^ aString
]

{ #category : 'api' }
PLBCodexClient >> send: aPLBRequest [

	| baseName promptFile outputFile stdoutFile stderrFile exitCode response |
	baseName := 'plb-' , UUID new asString.
	promptFile := FileLocator temp / (baseName , '-prompt.txt').
	outputFile := FileLocator temp / (baseName , '-output.json').
	stdoutFile := FileLocator temp / (baseName , '-stdout.txt').
	stderrFile := FileLocator temp / (baseName , '-stderr.txt').

	[
	promptFile writeStreamDo: [ :stream |
		stream nextPutAll: aPLBRequest prompt ].

	exitCode := LibC system: (self
			             buildShellCommandFor: aPLBRequest
			             promptFile: promptFile
			             outputFile: outputFile
			             stdoutFile: stdoutFile
			             stderrFile: stderrFile).
	response := self
		            buildResponseFor: aPLBRequest
		            exitCode: exitCode
		            outputFile: outputFile
		            stdoutFile: stdoutFile
		            stderrFile: stderrFile ] ensure: [
		{
			promptFile.
			outputFile.
			stdoutFile.
			stderrFile } do: [ :each | each exists ifTrue: [ each delete ] ] ].

	^ response
]
