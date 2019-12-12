#!/usr/bin/python
# -*- coding: utf-8 -*-

DOCUMENTATION = '''
---
module: win_hyperv_remove
version_added: "1.0"
short_description: Removes Hyper-V VM.
description:
    - Removes Hyper-V VM .
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
  force:
    description:
      - Use Force flag
    require: false
    default: null      
'''

EXAMPLES = '''
  # Remove VM
  win_hyperv_remove:
    name: myVM
    hypervisor: localhost
    force: true
'''

ANSIBLE_METADATA = {
    'status': ['preview'],
    'supported_by': 'community',
    'metadata_version': '1.1'
}
