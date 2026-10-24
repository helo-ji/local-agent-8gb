
# Start llama.cpp server with Qwen3.5-9B Q4_K_M for local agent use.
# Adjust the path to llama-server.exe if it lives elsewhere on your machine.

$LlamaDir = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\ggml.llamacpp_Microsoft.Winget.Source_8wekyb3d8bbwe"
Set-Location $LlamaDir

.\llama-server.exe `
  -hf daniloreddy/Qwen3.5-9B_GGUF:Q4_K_M `
  -c 4096 `
  --jinja `
  --chat-template-kwargs '{"enable_thinking": false}'
