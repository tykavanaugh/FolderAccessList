$folderName = Read-Host -Prompt 'Input folder name'
$output = "Groups with access:`n"
net use S:
Set-Location \\hgfs2\Shared\

$accessGroupsRaw = (Get-Acl "\\hgfs2\Shared\$foldername").Access

$i = 0
for (;$i -le ($accessGroupsRaw.Count - 1);$i++){
    $nameRaw = $accessGroupsRaw.IdentityReference[$i]
    $name = $nameRaw.Value.Split('\')[1]
    if (($name -ne "Administrators") -and ($name -ne "Domain Admins")){
        $output = $output + $name + "`n---------`n"
        $members = Get-ADGroupMember -Identity $name | select Name
        foreach($member in $members){
            $output = $output + $member.Name + "`n"
            }
        $output = $output + $members + "`n"
        }
    }


