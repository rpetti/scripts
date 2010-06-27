#!/bin/bash
sensors | grep '\(Temp\|fan\)' | sed -e 's/[\t ]*(.*//;s/[\t ]*$//'
