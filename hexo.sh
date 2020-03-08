#!/bin/sh
hexo clean
hexo generate
hexo deploy
git add .
git commit -m "Site Updated: $(date +"%Y-%m-%d %T")"
git push