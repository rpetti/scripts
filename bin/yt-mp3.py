#!/usr/bin/python

import json
import tempfile
import subprocess
import re
import os
import shutil
import sys
from pprint import pprint

mypwd = os.getcwd()
tempdir = tempfile.mkdtemp()
os.chdir(tempdir)

#TODO change to variable
url=sys.argv[1]

json_data = subprocess.check_output(["youtube-dl","-j",url])
metadata = json.loads(json_data)
title=metadata[u'title']
artist=metadata[u'uploader']
vid=metadata[u'id']
print title
print artist
print vid

if subprocess.call(["youtube-dl", "--id", "--write-thumbnail", "-x", "--audio-format", "mp3", "--audio-quality", "128K", url]) != 0:
	raise Exception('could not download')

if subprocess.call(["lame", "--ti", vid + ".jpg", "--tt", title, "--ta", artist, vid + ".mp3"]) != 0:
	raise Exception('could not tag')

os.rename(vid + '.mp3', '/home/rpetti/Music/'+title+'.mp3')

os.chdir(mypwd)
shutil.rmtree(tempdir)
