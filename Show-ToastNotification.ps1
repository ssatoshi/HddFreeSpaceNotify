using namespace Windows.UI.Notifications

function Show-ToastNotification
{
    Param (
        [string]$msg
    )
    $ErrorActionPreference = "Stop"

    $notificationTitle = $msg #"Server HDD Space Over!"

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    $template = [ToastNotificationManager]::GetTemplateContent([ToastTemplateType]::ToastText01)

    #Convert to .NET type for XML manipuration
    $toastXml = [xml] $template.GetXml()
    $toastXml.GetElementsByTagName("text").AppendChild($toastXml.CreateTextNode($notificationTitle)) > $null

    #Convert back to WinRT type
    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($toastXml.OuterXml)

    $toast = [ToastNotification]::new($xml)
    $toast.Tag = "AlertHddFreeSpace"
    $toast.Group = "ServerManagement"
    $toast.ExpirationTime = [DateTimeOffset]::Now.AddSeconds(30)

    $notifier = [ToastNotificationManager]::CreateToastNotifier("ServerManagerAlert")
    $notifier.Show($toast);
}

$notifyfile = "C:\temp\alert_over_hdd.json"

if(Test-Path $notifyfile)
{
    $msg = ""
    Get-Content $notifyfile | ConvertFrom-Json | % {
        $_ | % {
            $msg += [string]::Format("{0}が空き容量が規定値を下回っています。 `r`n残り：{1}% {2}MB`r`n",$_.drive,$_.free_space_percent,$_.free_space_size_mb)
        }
    }
    Show-ToastNotification -msg $msg
} 

