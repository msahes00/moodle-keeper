#!/bin/sh

# change to the data folder
cd /data

# remove any leftover lock files
rm -f *.lock

# run the moodle-dl script
moodle-dl