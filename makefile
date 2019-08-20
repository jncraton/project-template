SRC = index

all: test $(SRC).html slides.html revealjs

.PHONY: show showpdf clean deploy

slides.html: $(SRC).md makefile
	pandoc --mathjax -t revealjs -s -o $@ $< -V revealjs-url=revealjs -V theme=moon

revealjs:
	wget https://github.com/hakimel/reveal.js/archive/3.8.0.zip -O reveal.zip
	unzip reveal.zip
	mv reveal.js-3.8.0 revealjs
	rm reveal.zip

$(SRC)-md2html.html: $(SRC).pmd
	pweave --format=md2html $(SRC).pmd
	# Hack to remove padding from first line of code blocks
	sed -i -e "s/padding: 2px 4px//g" $(SRC).html

$(SRC).html: $(SRC).md
	pandoc --mathjax --standalone --css=style.css --toc -o $@ $<

$(SRC).tex: $(SRC).md
	pandoc --mathjax --standalone --css=style.css --toc -o $@ $<

$(SRC).md: $(SRC).pmd
	# Pandoc unfortunately doesn't support default args on command line
	# We get around this by calling pweave from within Python
	python3 -c "import pweave;pweave.rcParams['chunk']['defaultoptions']['wrap']=True;pweave.weave('$<',doctype='pandoc')"

$(SRC).py: $(SRC).pmd
	ptangle $(SRC).pmd

$(SRC).pdf: $(SRC).md
	pandoc --toc --variable documentclass=extarticle --variable fontsize=12pt --variable mainfont="FreeSans" --variable mathfont="FreeMono" --variable monofont="FreeMono" --variable monofontoptions="SizeFeatures={Size=8}" --include-in-head head.tex --no-highlight --mathjax --latex-engine=xelatex -s -o $@ $< 

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
	rm -rf revealjs
