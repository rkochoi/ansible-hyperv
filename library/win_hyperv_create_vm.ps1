#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy

$params = Parse-Args $args;
$result = @{};
Set-Attr $result "changed" $false;

$vmName = Get-Attr -obj $params -name name -failifempty $true -emptyattributefailmessage "missing required argument: name"
$hypervisor = Get-Attr -obj $params -name hypervisor -default localhost
$memory = Get-Attr -obj $params -name memory -failifempty $true -emptyattributefailmessage "missing required argument: memory"
$cpu = Get-Attr -obj $params -name cpu -failifempty $true -emptyattributefailmessage "missing required argument: cpu"
$vhdx = Get-Attr -obj $params -name vhdx -failifempty $true -emptyattributefailmessage "missing required argument: vhdx"
$vmpath = Get-Attr -obj $params -name vmpath -failifempty $true -emptyattributefailmessage "missing required argument: vmpath"
$state = Get-Attr -obj $params -name state -failifempty $true -emptyattributefailmessage "missing required argument: state"
$generation = Get-Attr -obj $params -name generation -failifempty $true -emptyattributefailmessage "missing required argument: generation"
$switch_name = Get-Attr -obj $params -name switch_name -failifempty $true -emptyattributefailmessage "missing required argument: switch_name"
$start = Get-Attr -obj $params -name start -default $null

if ("present","absent" -notcontains $state) {
  Fail-Json $result "The state: $state doesn't exist; State can only be: present, absent"
}

Function VM-Create {
  #Check If the VM already exists
  $CheckVM = Get-VM -name $vmName -ErrorAction SilentlyContinue

  if (!$CheckVM) {
    $cmd = "New-VM -Name $vmName -MemoryStartupBytes $memory -VHDPath $vhdx -Path $vmpath -Generation $generation -SwitchName '$switch_name'"

    # Create VM
    $results = Invoke-Expression $cmd
    # Set VM CPU and RAM
    if ($results) {
      $cmd = "Set-VM -Name $vmName -ProcessorCount $cpu -StaticMemory -MemoryStartupBytes $memory"
      $results = Invoke-Expression $cmd
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
    "present" {VM-Create}
    "absent" {VM-Delete}
  }
  Exit-Json $result;
} 
Catch {
  Fail-Json $result $_.Exception.Message
}
