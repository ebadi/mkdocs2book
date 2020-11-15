# MKDOCS2BOOK
Convert documentation in mkdocs format to a readable book in different formats (PDF/EPUB/HTML).

### How it works

1- Use [mkdocscombine](https://github.com/twardoch/mkdocs-combine.git) to combine all *.md files into a single pandoc (book.pd) file with the help of mkdocs.yml. 

2- Use only the latex template file from [pandoc-book-template](https://github.com/wikiti/pandoc-book-template.git)

* [pandoc-book-template](https://github.com/wikiti/pandoc-book-template.git) uses chapters/[0-9]-CHAPTERNAME.md format, not using mkdocs.yml file)
* [listings-setup.tex](listings-setup.tex)  is taken from this [stackexchange post](https://tex.stackexchange.com/questions/179926/pandoc-markdown-to-pdf-without-cutting-off-code-block-lines-that-are-too-long).
    

3- Use [Pandoc](https://pandoc.org/) to build the .PDF, .EPUB and HTML files

### Example:

```
sudo docker build -f Dockerfile -t mkdocs2book:latest .

git clone https://github.com/carla-simulator/carla.git documentation

sudo docker run -v=$PWD:/data/ mkdocs2book:latest /bin/bash -c "\
  cd /data/documentation ; \
  mkdocs build ; \
  mkdocscombine -o /data/book.pd; \
  pandoc --number-sections --toc -f markdown+grid_tables+table_captions -o /data/book.pdf /data/book.pd --pdf-engine=xelatex --listings -H /data/listings-setup.tex --template=/pandoc-book-template/templates/pdf.latex -V geometry:a4paper -V geometry:\"top=2cm, bottom=1.5cm, left=0.9cm, right=0.9cm\" -V mainfont=\"DejaVu Sans\"  -V monofont=\"DejaVu Sans Mono\" ; \
  pandoc --toc -f markdown+grid_tables -t epub -o /data/book.epub /data/book.pd ; \
  pandoc --toc -f markdown+grid_tables -t html -o /data/book.html /data/book.pd"
```
