$folderName = Read-Host -Prompt 'Input folder name'
$driveName = "\\hgfs\Users\SHARED" #change this to the drive
$output = "Groups with access:`n`n"
net use S:
net use N:
net use F:
net use I: \\hgfs\Israel #I drive requires this specific addition or it won't mount
Set-Location $driveName #this is not needed for the script, but makes it easier if you want to manually navigate

$accessGroupsRaw = (Get-Acl "$driveName$foldername").Access

$i = 0
for (;$i -le ($accessGroupsRaw.Count - 1);$i++){
    $nameRaw = $accessGroupsRaw.IdentityReference[$i]
    $prefix = $nameRaw.Value.Split('\')[0] #testing line
    $name = $nameRaw.Value.Split('\')[1]
    if ($name -ne "Domain Users"){
        if (($name -ne "Administrators") -and ($name -ne "Domain Admins")){
            $accessRights = $accessGroupsRaw[$i].FileSystemrights
            $output = $output + $name + "`n$accessRights`n"
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
    else{
        $output = $output + "`n!EVERYONE!"
        }
    }



#Known bug: When groups/users are set up in a way that is recursive,
#you'll usually get an error but it will complete anyway. The results will be accurate
#but you'll end up with the same group being repeated with users listed as the group name
#the SYSTEM group will likely cause this error for example. Just delete the extra output if
#the error pop up

#To use this type "\Folder name" without the double quotes when it asks you to input. Ignore
#the fact powershell IDE will syntax check it the script sees it as a string

#type $output to see the result
