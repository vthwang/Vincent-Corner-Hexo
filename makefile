update:
	git add .
	git commit -s -m "Site Updated: $(shell date +"%Y-%m-%d %T")"
	git push