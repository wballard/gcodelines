docs:
	echo '```' > readme.md
	./bin/mazecarver --help >> readme.md
	echo '' >> readme.md
	./bin/panelcarver --help >> readme.md
	echo '```' >> readme.md
