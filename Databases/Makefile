databases.html : databases.md databases.css
	pandoc --toc --from=markdown --to=html -c databases.css -o databases.html --number-sections --highlight-style zenburn databases.md
solutions.html : solutions.md databases.css
	pandoc --from=markdown --to=html -c databases.css -o solutions.html --highlight-style zenburn solutions.md 
