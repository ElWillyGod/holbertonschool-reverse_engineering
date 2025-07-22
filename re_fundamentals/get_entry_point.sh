#!/bin/bash

file_name="$1"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <elf-file>"
    exit 1
fi

if [[ ! -f "$file_name" ]]; then
    echo "Error: File '$file_name' not found."
    exit 1
fi

if ! readelf -h "$file_name" &>/dev/null; then
    echo "Error: '$file_name' is not a valid ELF file."
    exit 1
fi

magic_number=$(readelf -h "$file_name" \
    | awk '/Magic:/ { $1=""; sub(/^ +/, ""); print }')

class=$(readelf -h "$file_name" \
    | awk -F: '/Class:/ { sub(/^ +/, "", $2); print $2 }')

byte_order=$(readelf -h "$file_name" \
    | grep 'Data:' \
    | sed -E 's/^.*Data:.*(little endian|big endian).*$/\1/')

entry_point_address=$(readelf -h "$file_name" \
    | awk -F: '/Entry point address:/ { sub(/^ +/, "", $2); print $2 }')

source "$(dirname "$0")/messages.sh"
display_elf_header_info
