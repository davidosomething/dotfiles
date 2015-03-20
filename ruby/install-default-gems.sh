#!/bin/bash

# loop through default-gems file and install each one
while read gemname; do gem install "$gemname"; done < default-gems

