databases.html : databases.md databases.css
	pandoc --toc --from=markdown --to=html -c databases.css -o databases.html --number-sections --highlight-style zenburn databases.md
databases.pdf : databases.md databases.css
	pandoc --toc --from=markdown --to=latex -o databases.pdf -c databases.css --number-sections --highlight-style haddock databases.md
solutions.html : solutions.md databases.css
	pandoc --from=markdown --to=html -c databases.css -o solutions.html --highlight-style zenburn solutions.md 
