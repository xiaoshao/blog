#!/bin/sh
export NAME="No body No body But you Oh..."
git clone git@github.com:resiworks/resiworks.github.com public
cask exec emacs --batch -l emacs.el -f org-publish-all
