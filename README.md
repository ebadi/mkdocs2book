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
git clone https://github.com/ebadi/mkdocs-combine.git
git clone https://github.com/ebadi/pandoc-book-template.git
git clone https://github.com/carla-simulator/carla.git documentation


sudo rm book.pd book.pdf book.epub;

sudo docker run -v=$PWD:/data/ mkdocs2book:latest /bin/bash -c "\
  rm -rf /data/mkdocs-combine/mkdocs_combine.egg-info ; \
  pip3 install -e  /data/mkdocs-combine ; \
  cd /data/documentation ; \
  mkdocs build ; \
  mkdocscombine --admonitions-md -o /data/book.pd; \
  sed -i 's/---//g' /data/book.pd ; \
  sed '/TOREMOVE/d' -i /data/book.pd ; \
  pandoc --number-sections --toc -f markdown+grid_tables+table_captions -o /data/book.pdf /data/book.pd --pdf-engine=xelatex \
    --listings -H /data/listings-setup.tex \
    --template=/data/pandoc-book-template/templates/pdf.latex \
    --toc-depth=3 \
    -V papersize=a4 \
    -V geometry:\"top=2cm, bottom=2.5cm, left=1.9cm, right=1.9cm\" \
    -V documentclass=\"book\" \
    -V fontsize=12 \
    -V mainfont=\"DejaVuSerif\" \
    -V monofont=\"DejaVuSansMono\" ; \
  pandoc --toc -f markdown+grid_tables --template /data/pandoc-book-template/templates/epub.html -t epub -o /data/book.epub /data/book.pd ; "

```

