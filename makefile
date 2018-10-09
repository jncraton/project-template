SRC = index

all: test $(SRC).html slides.html

.PHONY: show showpdf clean deploy

slides.html: $(SRC).md makefile
	pandoc --mathjax -t revealjs -s -o $@ $< -V revealjs-url=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.6.0 -V theme=moon

$(SRC).odt: $(SRC).md
	pandoc --toc -o $@ $<

$(SRC)-md2html.html: $(SRC).pmd
	pweave --format=md2html $(SRC).pmd
	# Hack to remove padding from first line of code blocks
	sed -i -e "s/padding: 2px 4px//g" $(SRC).html

$(SRC).html: $(SRC).md
	pandoc --mathjax --standalone --css=style.css --toc -o $@ $<

$(SRC).md: $(SRC).pmd
	pweave --format=pandoc $(SRC).pmd

$(SRC).py: $(SRC).pmd
	ptangle $(SRC).pmd

$(SRC).pdf: $(SRC).md
	pandoc --toc --variable documentclass=extarticle --variable fontsize=12pt --variable mainfont="FreeSans" --variable monofont="FreeMono"  --mathjax --latex-engine=xelatex -s -o $@ $< 

show: $(SRC).html
	firefox $(SRC).html

showpdf: $(SRC).pdf
	firefox $(SRC).pdf
	
run: $(SRC).py
	python3 $(SRC).py

test: $(SRC).py
	cat testhead.py $(SRC).py > $(SRC)-test.py

	# Hack to prevent multiprocessing on module import
	sed -i -e "s/from multiprocessing/from multiprocessing.dummy/g" $(SRC)-test.py
	
	python3 -m doctest $(SRC)-test.py

readme.md: gen_readme.py
	python3 gen_readme.py > readme.md

netlifyctl:
	wget -qO- 'https://cli.netlify.com/download/latest/linux' | tar xz

deploy: netlifyctl $(SRC).pdf $(SRC).html
	./netlifyctl deploy

clean:
	rm -f $(SRC).txt $(SRC).odt $(SRC).docx $(SRC).pdf $(SRC).md $(SRC).py $(SRC)-test.py $(SRC).html slides.html
	rm -rf figures
	rm -rf __pycache__
	rm -f netlifyctl
