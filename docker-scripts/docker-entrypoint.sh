#!/bin/bash

# If any command fails, the script will exit immediately
set -e

# Check if Gemfile exists
if [ ! -f Gemfile ]; then
    echo "Can't find Gemfile, so don't have jekyll site here. "
    echo "Docker mounted it incorrectly."
    echo "Be sure you're in your jekyll site root and use something like this to launch the container: "
    echo ""
    echo "docker run -p 4000:4000 -v \$(pwd):/site bretfisher/jekyll-serve"
    echo ""
    echo "Noted: To create a new Jekyll site, you can run:"
    echo "docker run -v \$(pwd):/site bretfisher/jekyll new ."
    exit 1
fi

# Install gems
bundle install --retry 5 --jobs 20

# Run parameters to start the Jekyll server
exec "$@"