# PharoLLMBridge
PharoLLMBridge is a bridge between Pharo and LLM or AI-agent backends.
It lets Pharo code send prompts to external AI systems, receive results, and optionally parse those results into Pharo objects. 
The project is intentionally generic: it does not contain domain-specific logic. 
Instead, each client project builds its own prompts and decides how to interpret the returned data.

## Purpose
The goal of PharoLLMBridge is to make it easy to:
- send prompts from Pharo to an AI backend
- receive raw text or structured JSON responses
- support several backends behind a common API
- reuse the same bridge in different Pharo projects (for example: alesshosry/Adonis) 
 
## Current Backends
- OpenAI
- Codex
- Ollama

## Installation 
```smalltalk
Metacello new
	repository: 'github://alesshosry/PharoLLMBridge:main/src';
	baseline: 'PharoLLMBridge';
	load
```
 
## OpenAI Example
 
It expects OPENAI_API_KEY to be available in the environment; on Mac you can use this: ```launchctl setenv OPENAI_API_KEY "your key"```

```smalltalk
| request response |
request := PLBRequest new
	prompt: 'Return only valid JSON object {"names":["alerts"]} and nothing else.';
	expectedFormat: #json;
	yourself.
response := PLBOpenAIClient new send: request.
response parsedResult
```

Expected result:
a Dictionary('names' -> #('alerts'))
 
## Codex Example

PLBCodexClient sends prompts through the local Codex CLI.

```smalltalk
| request response |
request := PLBRequest new
	prompt: 'Return only valid JSON object {"names":["alerts"]} and nothing else.';
	expectedFormat: #json;
	yourself.
response := PLBCodexClient new send: request.
response parsedResult
```

This requires:
- local Codex installed
- Codex accessible from the configured command path

## Ollama Example

PLBOllamaClient sends prompts through the local Ollama server.

```smalltalk
request := PLBRequest new
	prompt: 'Return only valid JSON object {"names":["alerts"]} and nothing else.';
	expectedFormat: #json;
	yourself.
response := PLBOllamaClient new send: request.
response parsedResult
```

This requires: 
- Ollama installed on your machine
- the Ollama server running locally
- at least one model pulled locally (mistral, qwen ...)

Typical shell setup:
- ollama serve
- ollama pull qwen3-coder:30b

## Important: Response Format Must Be Specified In The Prompt

PharoLLMBridge does not infer the structure of the result by itself.
If you want automatic parsing to work, the prompt must explicitly state the expected response format.
For example, when expectedFormat := #json, the prompt should ask for valid JSON and nothing else.

### Good example:

"Return only valid JSON object {"names":["alerts"]} and nothing else."

### Another good example:

"Analyze this Angular fragment: "let alert of alerts".
Return only valid JSON object of the form {"names":[...]} and nothing else."

If the backend returns extra explanation text before or after the JSON, parsing may fail and parsedResult may be nil.

Recommended rule:
- always describe the expected structure in the prompt
- always say Return only valid JSON ... and nothing else
 
## Notes
- OpenAI is part of the default load group.
- Codex is optional.
- Direct LLM access is usually better for repetitive structured extraction tasks, this is why we implemented a package for OpenAI.
- For performance, batching prompts is recommended instead of sending many very small requests.

## Roadmap
Possible future extensions:
- additional backends such as Mistral or Ollama
- batch request helpers
- richer parser support
- session-oriented clients when needed
