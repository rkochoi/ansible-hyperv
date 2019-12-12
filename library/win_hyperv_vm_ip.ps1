#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy

$params = Parse-Args $args;
$result = @{};
Set-Attr $result "changed" $false;

$vmName = Get-Attr -obj $params -name name -failifempty $true -emptyattributefailmessage "missing required argument: name"
$hypervisor = Get-Attr -obj $params -name hypervisor -default localhost

Function VM-GetIp {
  $state = (Get-VM -Name $vmName).state

  if ($state) {
    $result.ipv4 = (Get-VM -Name $vmName |Get-VMNetworkAdapter).IPAddresses[0]
    $result.changed = $true
  }
  else {
    $result.changed = $false
  }
}

Try {
  VM-GetIp
  Exit-Json $result;
} 
Catch {
  Fail-Json $result $_.Exception.Message
}
