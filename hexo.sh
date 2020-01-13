#!/bin/sh
hexo clean
hexo generate
git add .
git commit -m 'Site Updated: date +"%Y-%m-%d %T"'
git push
hexo deploy
