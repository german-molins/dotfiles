#!/bin/bash

set -eu

eval "$(mise activate bash)"
pixi global sync
