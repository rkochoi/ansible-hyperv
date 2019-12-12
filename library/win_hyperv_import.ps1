#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy

$params = Parse-Args $args;
$result = @{};
Set-Attr $result "changed" $false;

$vmName = Get-Attr -obj $params -name name -failifempty $true -emptyattributefailmessage "missing required argument: name"
$hypervisor = Get-Attr -obj $params -name hypervisor -default localhost
$vmcx = Get-Attr -obj $params -name vmcx -failifempty $true -emptyattributefailmessage "missing required argument: vmcx"
$vhdx = Get-Attr -obj $params -name vhdx -default $null
$vmpath = Get-Attr -obj $params -name vmpath -failifempty $true -emptyattributefailmessage "missing required argument: vmpath"
$state = Get-Attr -obj $params -name state -failifempty $true -emptyattributefailmessage "missing required argument: state"
$copy = Get-Attr -obj $params -name copy -default $null
$generateid = Get-Attr -obj $params -name generateid -default $null
$start = Get-Attr -obj $params -name start -default $null

if ("present","absent" -notcontains $state) {
  Fail-Json $result "The state: $state doesn't exist; State can only be: present, absent"
}

Function VM-Import {
  #Check If the VM already exists
  $CheckVM = Get-VM -name $vmName -ErrorAction SilentlyContinue

  if (!$CheckVM) {
    $cmd = "Import-VM -Path $vmcx -VirtualMachinePath $vmpath -VhdDestinationPath $vmpath"

    if ($hypervisor) {
        $cmd += " -ComputerName $hypervisor"
    }

    if ($copy) {
      $cmd += " -Copy"
    }

    if ($generateid) {
      $cmd += " -GenerateNewId"
    }

    # Actual import
    $results = Invoke-Expression $cmd
    # Rename VM as is in parameter "name"
    if ($results) {
      $cmd = "Rename-VM -Name $($results.Name) -NewName $vmName"
      $renameVM = Invoke-Expression $cmd
    }
    if ($start) {
      VM-Start
    }
    $result.changed = $true
  } 
  else {
    $result.changed = $false
  }
}

Function VM-Start {
  $state = (Get-VM -Name $vmName).state

  if ($state) {
    if ($state -ne "Running") {
      Start-VM -Name $vmName
    }
  }
  else {
    $result.changed = $false
  }
}

Function VM-Delete {
  $state = (Get-VM -Name $vmName).state

  if ($state) {
    if ($state -eq "Running") {
      Stop-VM -Name $vmName -TurnOff
    }
    
    $cmd="Remove-VM -Name $vmName -Force"
    $results = Invoke-Expression $cmd
    $result.changed = $true
  }
  else {
    $result.changed = $false
  }
}

Try {
  switch ($state) {
    "present" {VM-Import}
    "absent" {VM-Delete}
  }
  Exit-Json $result;
} 
Catch {
  Fail-Json $result $_.Exception.Message
}
