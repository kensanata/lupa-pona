# Update all the documentation files
doc: README.md man

# Update the README file. The Perl script no only converts the POD
# documentation to Markdown, it also adds a table of contents.
README.md: lupa-pona
	./update-readme

# Create man pages.
man: lupa-pona.1

%.1: %
	pod2man $< $@

# Install scripts and man pages in ~/.local
install: ${HOME}/.local/bin/lupa-pona \
	${HOME}/.local/share/man/man1/lupa-pona.1

${HOME}/.local/bin/%: %
	cp $< $@

${HOME}/.local/share/man/man1/%: %
	cp $< $@

uninstall:
	rm \
	${HOME}/.local/bin/lupa-pona \
	${HOME}/.local/share/man/man1/lupa-pona.1
