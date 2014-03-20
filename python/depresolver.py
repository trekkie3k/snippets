#!/usr/bin/env python

# This snippet will resolve dependencies given in the files in ./scripts/ and generate a
# list representing the execution order.

import sys,os,re

def complist(req,avail):
  for item in req:
    if item not in avail:
      return False
  return True

scripts_dir="./scripts"

l_scripts = os.listdir(scripts_dir)

for item in l_scripts:
  if not re.search('.py$',item):
    l_scripts.remove(item)


d_depends = {}
for script in l_scripts:
  fh = open(scripts_dir + '/' + script)
  for item in fh.readlines():
    if re.search('^#depends:',item):
      depends = re.sub('\n$','',item)
      d_depends[script] = [line.rstrip('\n') for line in re.sub('#depends:','',item).split(',')]

l_execution = []

keystoremove = []
for key in d_depends.iterkeys():
  if len(d_depends[key]) == 1 and d_depends[key][0] == '':
    l_execution.append(key)
    keystoremove.append(key)

for item in keystoremove:
  d_depends.pop(item)

fulfilled = []
for item in l_execution:
  item = re.sub('.py$','',item)
  fulfilled.append(item)

while len(d_depends) > 0:
  keystoremove = []
  for key in d_depends.iterkeys():
    if complist(d_depends[key],fulfilled):
      l_execution.append(key)
      fulfilled.append(re.sub('.py$','',key))
      keystoremove.append(key)
  for item in keystoremove:
    d_depends.pop(item)


print fulfilled

print l_execution
