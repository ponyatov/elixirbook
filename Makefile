# \ <section:var>
MODULE    = $(notdir $(CURDIR))
OS        = $(shell uname -s)
MACHINE   = $(shell uname -m)
# / <section:var>
# \ <section:dir>
CWD       = $(CURDIR)
DOC       = $(CWD)/doc
BIN       = $(CWD)/bin
SRC       = $(CWD)/src
TMP       = $(CWD)/tmp
# / <section:dir>
# \ <section:tool>
WGET      = wget -c
LATEX     = pdflatex -halt-on-error --output-dir=$(TMP)
# / <section:tool>
# \ <section:obj>
TEX += tex/elixirbook.tex tex/header.tex
FIG += tmp/stack.pdf
TEX += tex/intro.tex
TEX += tex/bib.tex
# / <section:obj>
# \ <section:all>
# \ <section:all>
.PHONY: all
all: 	
	$(MAKE) pdf
tmp/%.pdf: tex/%.dot
	dot -Tpdf -o $@.crop $<
	pdfcrop $@.crop $@
# / <section:all>
.PHONY: pdf
pdf: $(DOC)/elixirbook.pdf
$(DOC)/elixirbook.pdf: $(TMP)/elixirbook.pdf
	cp $< $@
$(TMP)/elixirbook.pdf: $(TEX) $(FIG)
	clear ; cd tex ; $(LATEX) elixirbook
# / <section:all>
# \ <section:install>
.PHONY: install
install: $(OS)_install
	$(MAKE) update
.PHONY: update
update: $(OS)_update
.PHONY: $(OS)_install $(OS)_update
$(OS)_install $(OS)_update:
	sudo apt update
	sudo apt install -u `cat apt.txt`
# / <section:install>
# \ <section:merge>
MERGE  = Makefile README.md apt.txt .gitignore .vscode $(S)
# / <section:merge>
.PHONY: main
main:
	git push -v
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)
.PHONY: shadow
shadow:
	git pull -v
	git checkout $@
	git pull -v
