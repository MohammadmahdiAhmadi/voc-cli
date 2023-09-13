#!/usr/bin/bash

lang_code="fa"

# Get the selected text from the clipboard
text=$(xsel -o)

# Playing the text using 'trans' command
trans -sp -no-translate "$text"
