# PSReadLine Options
$PSReadLineOptions = @{
  EditMode = "vi"
  ViModeIndicator = "Prompt"
  HistorySearchCursorMovesToEnd = $true
  Colors = @{
    "Operator" = "DarkYellow"
    "Parameter" = "DarkYellow"
  }
}
Set-PSReadLineOption @PSReadLineOptions

# Key bindings
Set-PSReadLineKeyHandler -Chord 'j,k' -ViMode Insert -Function ViCommandMode

Set-PSReadLineKeyHandler -Chord 'Ctrl+p' -ViMode Insert -Function HistorySearchBackward

Set-PSReadLineKeyHandler -Chord 'Ctrl+n' -ViMode Insert -Function HistorySearchForward
