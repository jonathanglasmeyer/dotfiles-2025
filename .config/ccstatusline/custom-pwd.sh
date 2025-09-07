#!/bin/bash

# Get current directory
current_dir=$(pwd)

# Check if it's home directory
if [[ "$current_dir" == "$HOME" ]]; then
    echo "~"
else
    basename "$current_dir"
fi