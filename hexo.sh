#!/bin/sh
hexo cl
hexo g
git add .
git commit -m "update"
git push
hexo d
