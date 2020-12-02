#!/usr/bin/env bash

if [ ! -d "mkdocs-combine" ] ; then
    git clone "https://github.com/ebadi/mkdocs-combine.git" "mkdocs-combine"
fi

if [ ! -d "pandoc-book-template" ] ; then
    git clone "https://github.com/ebadi/pandoc-book-template.git" "mkdocs-combine"
fi

if [ ! -d $1 ] ; then
    echo "Documentation folder (./documentation) is not found in the current directory"
fi



rm -rf /data/mkdocs-combine/mkdocs_combine.egg-info
pip3 install -e  /data/mkdocs-combine
cd /data/$1
mkdocscombine --admonitions-md -o /data/$1.pd
sed -i 's/---//g' /data/$1.pd
sed '/TOREMOVE/d' -i /data/$1.pd
pandoc --number-sections --toc -f markdown+grid_tables+table_captions -o /data/$1.pdf /data/$1.pd --pdf-engine=xelatex \
    --listings -H /data/listings-setup.tex \
    --template=/data/pandoc-book-template/templates/pdf.latex \
    --toc-depth=3 \
    -V papersize=a4 \
    -V geometry:"top=2cm, bottom=1cm, left=1.5cm, right=1.5cm" \
    -V documentclass="book" \
    -V fontsize=12 \
    -V toc-depth=2
    
pandoc --toc -f markdown+grid_tables --template /data/pandoc-book-template/templates/epub.html -t epub -o /data/$1.epub /data/$1.pd


