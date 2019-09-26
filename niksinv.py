#!/usr/bin/python

import json
import requests

def main():
  res=requests.get('https://raw.githubusercontent.com/msilmser/tower-test/master/custom.json')
  data=res.json()
  print json.dumps(data, sort_keys=True, indent=2)
if __name__ == '__main__':
  main()
