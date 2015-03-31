#!/bin/sh
git clone git@github.com:resiworks/resiworks.github.com.git public
cask exec emacs --batch -l emacs.el -f org-publish-all
# run it again for archive.org
cask exec emacs --batch -l emacs.el -f org-publish-all
