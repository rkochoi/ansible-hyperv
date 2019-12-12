#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy

$params = Parse-Args $args;
$result = @{};
Set-Attr $result "changed" $false;

$vmName = Get-Attr -obj $params -name name -failifempty $true -emptyattributefailmessage "missing required argument: name"
$hypervisor = Get-Attr -obj $params -name hypervisor -default localhost
$force = Get-Attr -obj $params -name state -default true

Function VM-Delete {
  $state = (Get-VM -Name $vmName).state

  if ($state) {
    if ($state -eq "Running") {
      Stop-VM -Name $vmName -TurnOff
    }

    $cmd="Remove-VM -Name $vmName"
    if ($force) {
        $cmd += " -Force"
    }
    $results = Invoke-Expression $cmd
    $result.changed = $true
  }
  else {
    $result.changed = $false
  }
}

Try {
  VM-Delete
  Exit-Json $result;
} 
Catch {
  Fail-Json $result $_.Exception.Message
}
