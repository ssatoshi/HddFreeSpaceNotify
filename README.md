# HddFreeSpaceNotify
サーバの空き容量が規定以下になるとトースト通知する

Test-HddFreeSpace.ps1 に HDD空き容量の制限値と
通知ファイルの出力先を記述する。
通知ファイルの出力先は共有フォルダにする。

Test-HddFreeSpace.ps1 をサーバのタスクスケジューラで定義。
１日１回程度でいいと思う。

Show-ToastNotification.ps1をクライアントのタスクスケジューラで定義する。
１時間に１回
