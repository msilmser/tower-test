#!/usr/bin/python

import json

data = {
  "_meta": {
    "hostvars": {
      "host_in_group1_1": {
        "ansible_host": "10.0.1.1"
      }, 
      "host_in_group1_2": {
        "ansible_host": "10.0.1.2"
      }
    }
  }, 
  "all": {
    "hosts": [
      "host_in_all"
    ]
  }, 
  "group1": {
    "hosts": [
      "host_in_group1_1", 
      "host_in_group1_2"
    ], 
    "vars": {
      "ansible_port": 2222, 
      "ansible_user": "root"
    }
  }, 
  "group12": {
    "children": [
      "group1", 
      "group2"
    ]
  }, 
  "group2": {
    "hosts": [
      "host_in_group1_1", 
      "host_in_group2_1", 
      "host_in_group3_1", 
      "host_in_group4_1", 
      "host_in_group5_1"
    ]
  }
}

print json.dumps(data, sort_keys=True, indent=2)
