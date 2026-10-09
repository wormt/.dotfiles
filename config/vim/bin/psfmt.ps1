$s = [Console]::In.ReadToEnd()
Invoke-Formatter -ScriptDefinition $s -Settings CodeFormattingOTBS
