# dark_slack_theme
Powershell script to add dark theme to Slack 

This script is intended to update the Slack theme by using the latest version installed via sorting and identifying the directory that was 
last updated (in case there is more than one version) then concatenate with the path of ssb-interop.js ($FullPath)

```
$VersionPath = "C:\Users\$env:UserName\AppData\Local\slack\app-*"
$PathContent = Get-ChildItem $VersionPath -Recurse | Where-Object { $_.PSIsContainer } | Sort-Object LastWriteTime | Select-Object -last 1
$JsPath = "\resources\app.asar.unpacked\src\static\ssb-interop.js"
$FullPath = "$($PathContent)" + "$($JsPath)"
$FileExists = Test-Path $FullPath
$NightModeId = "slack-night-mode"
$SlackDarkTheme = @'

document.addEventListener('DOMContentLoaded', function() {
 $.ajax({
   url: 'https://raw.githubusercontent.com/laCour/slack-night-mode/master/css/raw/black.css',
   success: function(css) {
     $("<style></style>").appendTo('head').html(css);
   }
 });
}); 
'@
$ChkSlackDarkTheme = Get-Content $FullPath | Select-String -Pattern $NightModeId

if ($FileExists) {
    if (!($ChkSlackDarkTheme)) {
    Add-Content -Path $FullPath -Value $SlackDarkTheme
  }
}

else {
    Write-Output "Slack is already using the dark theme"
}
```
