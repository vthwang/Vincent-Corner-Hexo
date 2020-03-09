#!/bin/sh
git add .
git commit -m "Site Updated: $(date +"%Y-%m-%d %T")"
git push