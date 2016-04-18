all:  build

# command for vim autocmd
#onsave: all
onsave:

build:
	pandoc *.md -o API.pdf \
		--smart \
		--toc \
		-V toc-depth=2 \
		--number-sections \
		-V papersize=A4 \
		-V documentclass=article \
		-V geometry=margin=2.5cm \
		-V fontsize=11pt \
		-V linestretch=1.25 \
		-V fontfamily=sourceserifpro \
		-V links-as-notes
.PHONY: build
	# working fonts: libertine, ebgaramond, sourceserifpro, alegreya


# convert additional files, count words and characters
prepare: convert-svg count

# TODO: pipe plaintext to two wc. inefficient right now.
count:
	pandoc --to plain main.md | wc -m > charcount
	pandoc --to plain main.md | wc -w > wordcount
.PHONY: wordcount

convert-svg:
	for file in *.svg ; do \
		inkscape $$file  -A $${file%.*}.pdf ; \
  done
.PHONY: convert-svg

clean:
	rm -r *.pdf charcount wordcount
.PHONY: clean
