#!/usr/bin/python

import json
import tempfile
import subprocess
import re
import os
import shutil
from pprint import pprint

mypwd = os.getcwd()
tempdir = tempfile.mkdtemp()
os.chdir(tempdir)

#TODO change to variable
url="http://youtu.be/Xe1dga2K9O4"

match = re.search('.*/([^/&]*)', url)
vid=''
if match:
	vid=match.group(1)
	print "downloading " + vid
else:
	raise Exception('could not get id from url')

subprocess.call(["youtube-dl", "--id", "--write-thumbnail", "--write-info-json", "-x", "--audio-format", "mp3", "--audio-quality", "128K", url])

json_data = open(vid+".info.json")
metadata = json.load(json_data)
title=metadata[u'title']
artist=metadata[u'uploader']
print title
print artist
subprocess.call(["lame", "--ti", vid + ".jpg", "--tt", title, "--ta", artist, vid + ".mp3"])

os.chdir(mypwd)
shutil.rmtree(tempdir)
