#!/usr/bin/python
# -*- coding: utf-8 -*-

DOCUMENTATION = '''
---
module: win_hyperv_create_vm
version_added: "1.0"
short_description: Creates Hyper-V VM with existing VHDX image.
description:
    - Creates Hyper-V VM with existing VHDX image.
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
  memory:
    description:
      - Specify startup memory
    require: true
    default: null
  cpu:
    description:
      - Specify CPU count
    require: true
    default: null
  vhdx:
    description:
      - Specify path of VHDX file for VM
    require: true
    default: null
  vmpath:
    description:
      - Specify destination path of imported VM
    require: true
    default: null 
  generation:
    description:
      - Specify generation of new VM
    require: true
    default: true
  switch_name:
    description:
      - Specify Virtual Switch name
    require: true
    default: true
  start:
    description:
      - Start VM right after creation
    require: false
    default: null   
'''

EXAMPLES = '''
  # Import VM
  win_hyperv_create_vm:
    name: myVM
    hypervisor: localhost
    memory: 2GB
    cpu: 2
    vhdx: 'C:\\VM\\win10.vhdx'
    vmpath: 'C:\\VM\\'
    generation: 1
    switch_name: 'Default Switch'
    start: true
    state: present
'''

ANSIBLE_METADATA = {
    'status': ['preview'],
    'supported_by': 'community',
    'metadata_version': '1.1'
}
