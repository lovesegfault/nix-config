#!/usr/bin/env bash

grim -t png -g "$(slurp)" - |
	swappy -f -
