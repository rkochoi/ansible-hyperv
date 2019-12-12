#!/usr/bin/python
# -*- coding: utf-8 -*-

DOCUMENTATION = '''
---
module: win_hyperv_turn_vm
version_added: "1.0"
short_description: Perform Turn on/off Hyper-V VM.
description:
    - Removes Perform Turn on/off Hyper-V VM.
options:
  name:
    description:
      - Name of VM
    required: true
  hypervisor:
    description:
      - HyperV host
    required: false
    default: null
  turn:
    description:
      - Specify on/off action
    require: true
    default: null    
  force:
    description:
      - Use Force flag
    require: false
    default: null      
'''

EXAMPLES = '''
  # Remove VM
  win_hyperv_turn_vm:
    name: myVM
    hypervisor: localhost
    turn: off
    force: true
'''

ANSIBLE_METADATA = {
    'status': ['preview'],
    'supported_by': 'community',
    'metadata_version': '1.1'
}
