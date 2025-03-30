#!/bin/sh

DEVBOX_DOCS_FILE=docs/devbox.md

devbox generate readme "$DEVBOX_DOCS_FILE" --config home/dot_local/share/devbox/global/default/
echo "Generated Devbox documentation at '$DEVBOX_DOCS_FILE'."
