#!/bin/sh
git clone git@github.com:resiworks/resiworks.github.com public
cask exec emacs --batch -l emacs.el -f org-publish-all
