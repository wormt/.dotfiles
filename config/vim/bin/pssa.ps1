Invoke-ScriptAnalyzer -Path $args[0] -EnableExit | ForEach-Object {
    '{0}:{1}:{2}: [{3}] {4}' -f $_.ScriptPath, $_.Line, $_.Column, $_.RuleName, $_.Message
}
