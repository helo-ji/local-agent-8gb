
# local-agent-8gb

Running a coding agent completely locally on an 8GB VRAM GPU

## What this is

A feasibility test: can an 8GB VRAM machine (RTX 3060 Ti) run a usable agentic coding assistant with no cloud API, no API key, and no cost? This repo records the setup, the tests, and the failure modes.

## Stack

- **GPU**: NVIDIA RTX 3060 Ti, 8GB VRAM
- **OS**: Windows
- **Inference**: llama.cpp (WinGet install)
- **Model**: Qwen3.5-9B, Q4_K_M quantization (~5.8GB)
- **Agent**: OpenCode connected to llama.cpp via a local OpenAI-compatible endpoint

## Setup summary

llama.cpp is started with `--jinja` and thinking disabled, which is required for tool-call parsing:

```powershell
llama-server.exe -hf daniloreddy/Qwen3.5-9B_GGUF:Q4_K_M -c 4096 --jinja --chat-template-kwargs '{"enable_thinking": false}'
```

OpenCode connects through `configs/opencode.json`, which points at the local endpoint. No API key is used because llama-server is bound to `127.0.0.1` and requires no authentication.

### Self-verification

After writing each file, the model ran it and reported the output. This is useful behavior. It catches syntax errors before the user sees them.

### Multi-step chaining works

Create, run, delete, recreate was completed as a sequence of tool calls in a single session.

## Known issue: tool-call parsing in llama.cpp

Qwen3.5 tool calls have a known parsing problem in llama.cpp: when the model emits text before `<tool_call>` (for example, skipping the closing `</think>` tag), the parser can treat the tool call as thinking content, and the agent receives an empty call.

The `enable_thinking: false` flag reduces the frequency but does not eliminate it. Failures of this kind are not model errors and are not configurable away on the client side.

## Conclusion

On 8GB VRAM, Qwen3.5-9B Q4_K_M is usable for simple file operation like create, run, delete, recreate, with acceptable latency (roughly 10–14 seconds per task in these tests).

It is not reliable for longer multi-step tasks where context growth makes the tool-call parsing issue more likely. AA smaller model (4B) would likely be more reliable for this hardware, while a cloud API would trade local privacy and zero cost for higher quality and stability

## Repo layout

```text
local-agent-8gb/
├── README.md
├── opencode.json
├── scripts/
│   └── start-llama.ps1
├── notes/
│   ├── troubleshooting.md
│   └── test-log.md
└── .gitignore
```
