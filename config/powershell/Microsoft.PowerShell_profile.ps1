$env:PATH = "$env:HOME/.local/bin:$env:HOME/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

function prompt {
	"$($executionContext.SessionState.Path.CurrentLocation)$(': ' * ($nestedPromptLevel + 1))";
}

Set-PSReadLineOption -EditMode Vi -HistorySavePath ~/.pwsh_history -HistorySaveStyle SaveIncrementally -MaximumHistoryCount 696969 -HistoryNoDuplicates -HistorySearchCursorMovesToEnd #-Colors @{
#	Command="$([char]0x1b)[95m"
#	ContinuationPrompt="$([char]0x1b)[90m"
#	Default="$([char]0x1b)[30m"
#	Emphasis="$([char]0x1b)[95m"
#	Member="$([char]0x1b)[90m"
#	Number="$([char]0x1b)[90m"
#	Operator="$([char]0x1b)[30m"
#	Parameter="$([char]0x1b)[30m"
#	Type="$([char]0x1b)[30m"
#	InlinePrediction="$([char]0x1b)[90m"
#	ListPrediction="$([char]0x1b)[90m"
#	ListPredictionTooltip="$([char]0x1b)[90m"
#}

#$PSStyle.FileInfo.Directory="`e[106m"
#$PSStyle.Formatting.FeedbackAction="`e[32m"

#Set-Alias -Name vi -Value vim

if ( Test-Path ~/.pyenv/bin/Activate.ps1 ) { . ~/.pyenv/bin/Activate.ps1 }
