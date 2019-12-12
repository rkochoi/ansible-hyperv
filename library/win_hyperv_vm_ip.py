#!/usr/bin/python
# -*- coding: utf-8 -*-

DOCUMENTATION = '''
---
module: win_hyperv_vm_ip
version_added: "1.0"
short_description: Get VM ip address by name.
description:
    - Get VM ip address by name.
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
'''

EXAMPLES = '''
  # Get VM ip address by name
  win_hyperv_get_ip:
    name: myVM
    hypervisor: localhost
'''

ANSIBLE_METADATA = {
    'status': ['preview'],
    'supported_by': 'community',
    'metadata_version': '1.1'
}
