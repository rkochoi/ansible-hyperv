#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy

$params = Parse-Args $args;
$result = @{};
Set-Attr $result "changed" $false;

$vmName = Get-Attr -obj $params -name name -failifempty $true -emptyattributefailmessage "missing required argument: name"
$hypervisor = Get-Attr -obj $params -name hypervisor -default localhost
$action = Get-Attr -obj $params -name turn -failifempty $true -emptyattributefailmessage "missing required argument: turn"
$force = Get-Attr -obj $params -name state -default true

if ("on","off" -notcontains $action) {
    Fail-Json $result "The turn action: $action doesn't exist; Trun action can only be: on, off"
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


Function VM-Stop {
    $state = (Get-VM -Name $vmName).state
  
    if ($state) {
      $cmd = "Stop-VM -Name $vmName"
      if ($force) {
          $cmd += " -Force"
      }
      Invoke-Expression $cmd
    }
    else {
      $result.changed = $false
    }
  }

Try {
    switch ($action) {
        "on" {VM-Start}
        "off" {VM-Stop}
      }
      Exit-Json $result;
} 
Catch {
  Fail-Json $result $_.Exception.Message
}
