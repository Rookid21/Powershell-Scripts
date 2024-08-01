# Function to check if the OS is Windows 10
function Test-IsWindows10 {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    $version = [version]$os.Version
    return ($version.Major -eq 10 -and $version.Build -lt 22000)  # Windows 11 build numbers start from 22000
}

# Check if the system is Windows 10
if (Test-IsWindows10) {
    $Optional_Logo = 'C:\Temp\Logo.jpg'
    $Header = "Windows 11 Upgrade"
    $Header_2 = "Please Follow the document below to upgrade to Windows 11"

    $ToastXmlContent = @"
<toast launch="reminderLaunchArg" scenario="incomingCall">
  <visual>
    <binding template="ToastGeneric">
      <text>$($Header)</text>
      <text>$($Header_2)</text>
      <image src='$($Optional_Logo)' placement='appLogoOverride'/>
    </binding>
  </visual>

  <!-- Actions for the user to take on the snooze button -->
  <actions>
    <input id="idSnoozeTime" type="selection" defaultInput="5">
      <selection id="1440" content="24 hours" />
    </input>

    <action activationType="system" arguments="snooze" hint-inputId="idSnoozeTime" content="Remind Me Later" />

    <action arguments="$([System.Security.SecurityElement]::Escape('https://twosloo.com'))" content="Windows 11 Upgrade Documents" activationType="protocol" />
  </actions>
</toast>
"@

    $XmlDocument = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]::New()
    $XmlDocument.loadXml($ToastXmlContent)

    # Use the AppId for showing the toast notification
    $AppId = 'Microsoft.WindowsTerminal_8wekyb3d8bbwe!App'
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::CreateToastNotifier($AppId).Show($XmlDocument)
} else {
    Write-Host "This script only runs on Windows 10 systems."
}
