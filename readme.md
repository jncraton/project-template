Project Template
================

A template for computer science projects.

This is a set of files to easily get started on a new CS project. Python code and text is placed in the file `index.pmd` and weaved using Pweave and the included makefile. 

The following output files can be generated using the makefile (e.g. `make index.html`):

- `index.md` for markdown output
- `index.html` for html output
- `index.pdf` for PDF output (requires xelatex)
- `index.odt` for Open Document Text output

Testing
-------

All Python code can be pulled from the document and executed using `doctest` by calling `make test`.

Additional files are provided to allow a project to be easily tested on TravisCI and deployed using Netlify.

Getting Started
---------------

You likely just want the files from this repository without any git history so that you can start from a fresh state. Here's one quick way to get these files into a directory:

    git clone --depth 1 https://github.com/jncraton/project-template.git
    mv project-template/* .
    rm -rf project-template

These commands are also available to be executed directly in the included `new.sh` script.