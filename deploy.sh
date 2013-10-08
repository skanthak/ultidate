#!/bin/sh

rsync -rv --size-only --exclude "*~" --exclude ".svn" --exclude "log" --exclude "deploy.sh" . www.dike.de:webapps/ultidate

