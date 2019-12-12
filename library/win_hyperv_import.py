#!/usr/bin/python
# -*- coding: utf-8 -*-

DOCUMENTATION = '''
---
module: win_hyperv_import
version_added: "1.0"
short_description: Imports Hyper-V VM from image.
description:
    - Imports Hyper-V VM from image.
options:
  name:
    description:
      - Name of VM
    required: true
  state:
    description:
      - State of VM
    required: true
    choices:
      - present
      - absent
    default: present
  hypervisor:
    description:
      - HyperV host
    required: false
    default: null
  vmcx:
    description:
      - Specify path of VMCX file for VM
    require: true
    default: null
  vhdx:
    description:
      - Specify path of VHDX file for VM
    require: false
    default: null
  vmpath:
    description:
      - Specify destination path of imported VM
    require: true
    default: null 
  copy:
    description:
      - Add -Copy argument to Import-VM cmdlet
    require: false
    default: true
  generateid:
    description:
      - Generates unique ID for imported VM
    require: false
    default: true
  start:
    description:
      - Start VM right after import
    require: false
    default: null   
'''

EXAMPLES = '''
  # Import VM
  win_hyperv_import:
    name: myVM
    hypervisor: localhost
    vmcx: 'C:\\IMAGES\\myVM\\Virtual Machines\\'
    vmpath: 'C:\\VM\\'
    copy: true
    generateid: true
    start: true
    state: present
'''

ANSIBLE_METADATA = {
    'status': ['preview'],
    'supported_by': 'community',
    'metadata_version': '1.1'
}
