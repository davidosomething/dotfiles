#!/usr/bin/env bash

set -euo pipefail

# Check if required commands are available
for cmd in gh fzf curl unzip; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: $cmd is required but not installed." >&2
    exit 1
  fi
done

# Get list of releases
echo "Fetching Maple Mono releases..."
releases=$(gh release list --repo subframe7536/maple-font --json tagName --jq '.[].tagName')

if [ -z "$releases" ]; then
  echo "Error: Could not fetch releases from the repository." >&2
  exit 1
fi

# Use fzf to select a release
selected_release=$(echo "$releases" | fzf --prompt="Select Maple Mono Release: " --height=40% --layout=reverse --border)

if [ -z "$selected_release" ]; then
  echo "No release selected. Exiting."
  exit 0
fi

echo "Selected release: $selected_release"

# Create temporary directory
temp_dir=$(mktemp -d)

# Download the zip file
pat=MapleMonoNormalNL-NF-CN-unhinted.zip
gh release download --repo subframe7536/maple-font "$selected_release" --pattern "$pat" --dir "$temp_dir"
zip_path="$temp_dir/MapleMonoNormalNL-NF-CN-unhinted.zip"
if [ ! -f "$zip_path" ]; then
  echo "Error: Failed to download the zip file." >&2
  exit 1
fi

# Extract the required files
echo "Extracting files..."
unzip -j "$zip_path" "*/LICENSE.txt" -d "$temp_dir" 2>/dev/null ||
  unzip -j "$zip_path" "LICENSE.txt" -d "$temp_dir"

unzip -j "$zip_path" "*MapleMonoNormalNL-NF-CN-Regular.ttf" -d "$temp_dir"

# Check if extraction was successful
license_file=$(find "$temp_dir" -name "LICENSE.txt" -type f | head -n 1)
ttf_file=$(find "$temp_dir" -name "MapleMonoNormalNL-NF-CN-Regular.ttf" -type f | head -n 1)

if [ ! -f "$license_file" ] || [ ! -f "$ttf_file" ]; then
  echo "Error: Could not find required files in the archive." >&2
  exit 1
fi

# Move files to the fonts directory
fonts_dir="./fonts"
mkdir -p "$fonts_dir"

cp "$license_file" "$fonts_dir/MapleMonoNormalNL-NF-CN-Regular--LICENSE.txt"
cp "$ttf_file" "$fonts_dir/MapleMonoNormalNL-NF-CN-Regular.ttf"

echo "Successfully updated Maple Mono font files in $fonts_dir"
echo "Release: $selected_release"
