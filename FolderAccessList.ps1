$folderName = Read-Host -Prompt 'Input folder name'
$driveName = "" #update me
$output = "Groups with access:`n`n"
net use S:
net use N:
Set-Location $driveName

$accessGroupsRaw = (Get-Acl "$driveName$foldername").Access

$i = 0
for (;$i -le ($accessGroupsRaw.Count - 1);$i++){
    $nameRaw = $accessGroupsRaw.IdentityReference[$i]
    $name = $nameRaw.Value.Split('\')[1]
    if (($name -ne "Administrators") -and ($name -ne "Domain Admins")){
        $output = $output + $name + "`n---------`n"
        $members = Get-ADGroupMember -Identity $name | select Name
        foreach($member in $members){
            $memberName = $member.Name
            $memberName = $memberName.Replace("'","''")
            $memberObject = Get-ADUser -Filter "Name -eq '$memberName'"
            if ($memberObject.Enabled -eq $true){
                $output = $output + $member.Name + "`n"
                }
            }
        $output = $output + $members + "`n"
        }
    }


