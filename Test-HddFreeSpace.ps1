
# 通知ファイル
$notifyfile = "C:\temp\alert_over_hdd.json"

# 最低HDD空き容量率(%) この値を下回るとアラート 
$free_limit_par = 25

if(Test-Path $notifyfile)
{
    # 前回実行時に作成した通知ファイルが残っている場合は削除する
    Remove-Item $notifyfile -Force
}

# アラートデータ
$result = @()

# 全ドライブに対して探索する
Get-PSDrive -PSProvider FileSystem | % {
    
    # HDD容量(MB)
    $entire = [int](($_.Free + $_.Used) / 1MB)
    
    if(0 -lt $entire)
    {
        # HDD容量が0以上の場合のみ(DVDなどは除外)

        # HDD空き容量(MB)
        $free = ($_.Free / 1MB)
        
        # 空き容量率
        $free_per = ([math]::Floor($free / $entire * 100)) 
        
        if ($free_per -lt $free_limit_par)
        {
            # 空き容量既定を下回っている場合はアラートデータに挿入
            $r = @{}
            $r["drive"] = $_.Root
            $r["free_space_percent"] = $free_per
            $r["free_space_size_mb"] = [int]$free
            $result += $r     
        }
    }
}

if(0 -lt $result.Count)
{
    # アラート対象データが存在する場合はJSONファイルとして出力
    $json = (ConvertTo-Json -InputObject $result -Compress)
    Out-File -FilePath $notifyfile -InputObject $json

}
