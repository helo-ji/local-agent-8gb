
# Troubleshooting

## `llama-server` not recognized

After `winget install`, the command may not be on PATH in the current terminal. Either open a new PowerShell window, or `cd` into the package directory:

```powershell
cd "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\ggml.llamacpp_Microsoft.Winget.Source_8wekyb3d8bbwe"
.\llama-server.exe ...
```

## `failed to fit params to free device memory: n_gpu_layers already set by user to 99, abort`

Caused by passing `-ngl 99` on an 8GB card. Remove `-ngl` and let llama.cpp allocate layers automatically.

## Tool calls not executing / empty tool call

Known Qwen3.5 + llama.cpp parsing issue. When the model emits text before `<tool_call>`, the parser can swallow the call as thinking content. `enable_thinking: false` reduces the frequency. Retry the prompt, or split the task into smaller steps.

## `tail` not recognized in PowerShell

PowerShell has no `tail`. Use `Select-Object -Last 30` instead.
