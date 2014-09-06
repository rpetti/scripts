#!/usr/bin/python

import sys
import json
import subprocess

workspace_json = subprocess.check_output("i3-msg -t get_workspaces", shell=True);

workspaces=json.loads(workspace_json)

target=sys.argv[1]

workspaces.reverse()

lastworkspace=""
targetworkspacename=target

for workspace in workspaces:
	if str(workspace['num']) != target:
		continue
	if not workspace['visible']:
		lastworkspace=workspace['name']
		continue
	if workspace['visible']:
		if not lastworkspace == "":
			targetworkspacename=lastworkspace
			break

if not lastworkspace=="":
	targetworkspacename=lastworkspace

subprocess.check_output(['i3-msg','workspace',targetworkspacename])
#print targetworkspacename
