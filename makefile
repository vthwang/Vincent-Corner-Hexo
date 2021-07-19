update:
	git add .
	git commit -m "Site Updated: $(shell date +"%Y-%m-%d %T")"
	git push