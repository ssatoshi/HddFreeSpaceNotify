
# �ʒm�t�@�C��
$notifyfile = "C:\temp\alert_over_hdd.json"

# �Œ�HDD�󂫗e�ʗ�(%) ���̒l�������ƃA���[�g 
$free_limit_par = 25

if(Test-Path $notifyfile)
{
    # �O����s���ɍ쐬�����ʒm�t�@�C�����c���Ă���ꍇ�͍폜����
    Remove-Item $notifyfile -Force
}

# �A���[�g�f�[�^
$result = @()

# �S�h���C�u�ɑ΂��ĒT������
Get-PSDrive -PSProvider FileSystem | % {
    
    # HDD�e��(MB)
    $entire = [int](($_.Free + $_.Used) / 1MB)
    
    if(0 -lt $entire)
    {
        # HDD�e�ʂ�0�ȏ�̏ꍇ�̂�(DVD�Ȃǂ͏��O)

        # HDD�󂫗e��(MB)
        $free = ($_.Free / 1MB)
        
        # �󂫗e�ʗ�
        $free_per = ([math]::Floor($free / $entire * 100)) 
        
        if ($free_per -lt $free_limit_par)
        {
            # �󂫗e�ʊ����������Ă���ꍇ�̓A���[�g�f�[�^�ɑ}��
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
    # �A���[�g�Ώۃf�[�^�����݂���ꍇ��JSON�t�@�C���Ƃ��ďo��
    $json = (ConvertTo-Json -InputObject $result -Compress)
    Out-File -FilePath $notifyfile -InputObject $json

}
