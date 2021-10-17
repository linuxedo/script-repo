#!/bin/bash

repo="JetBrains"
name="JetBrainsMono"

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | 
    grep '"tag_name":' | 
    sed -E 's/.*"([^"]+)".*/\1/'
}

# Define the latest url
version=$(get_latest_release "$repo/$name")
file_name="JetBrainsMono-${version:1}.zip"
url="https://github.com/$repo/$name/releases/download/$version/$file_name"


# Clear the existing folders
rm -rf /tmp/$file_name
rm -rf /tmp/fonts

# Download the zip
wget $url -P /tmp/

# Extract and install the fonts
unzip -o /tmp/$file_name -d /tmp/

# Install the fonts
if [ `id -u` = 0 ] ; then
  sudo mv /tmp/fonts /usr/share/fonts/JetBrainsMono
else
  mv /tmp/fonts ~/.local/share/fonts/JetBrainsMono
fi
fc-cache -f -v

# Clean the tmp dir
rm -rf /tmp/$file_name
rm -rf /tmp/fonts