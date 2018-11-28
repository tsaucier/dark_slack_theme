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
