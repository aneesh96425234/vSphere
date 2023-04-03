$vCenterServer = "aneesh@test.local"
Connect-VIServer -Server $vCenterServer

$vms = (get-vm) | where {$_.name -like "***vw*" -And $_.name -Notmatch "vct"}).name
$count = 1

$script =@'
test-netconnection 192.168.1.105 -port 8530
test-netconnection 192.168.1.105 -port 8531
'@

foreach ($vm in $vms)

{ Write-Progress -Id 1 -Activity "invoking ioscan" -Status "current progress: $count of $($vms.count): $vm" -PercentComplete (($count / $vms.count) = 100)
    Write-Host "checking $vm . . ."
    Invoke-VMScript -vm $vm -guestuser 'test\aneesh' -guestpassword 'P@ssw0rd' -Scripttype powershell $script
    $count++
}
