
function Prompt {
    $esc = [char]27
	$col = If ($LASTEXITCODE -gt 0) { "$esc[00;31;1m" } Else { "$esc[00;36;1m" } 

	#$loc = $executionContext.SessionState.Path.CurrentLocation.Path.Replace($env:HOME, "~")
	$loc = $executionContext.SessionState.Path.CurrentLocation.Path
	$path = Split-Path $loc -Leaf

	if ($loc -eq $env:HOME) { $path = "~" }
	$reset = "$esc[0m"

	return "$col PS $path > $reset"
}

Remove-Alias -Name rd
function rd {
	$tmpfile = New-TemporaryFile
	ranger --choosedir=$tmpfile -- $(Get-Location)
	cd $(Get-Content $tmpfile)
	Remove-Item $tmpfile
}

#Set-Alias -Name rd  -Value $env:HOME/bin/rd.ps1
Set-Alias -Name ls  -Value exa

function dfs  { & git --git-dir=$env:HOME/.dotfiles/ --work-tree=$env:HOME $args }
function cat  { & bat --plain $args }
function less { & bat --plain $args }
function tree { & exa --tree $args }
function rg   { & rg -p $args }

fortune | cowsay
echo ""