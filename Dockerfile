# Use the official Ruby image as a base and name the build stage "jekyll"
FROM ruby:3.1-slim-bullseye AS jekyll

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  git \
  && rm -rf /var/lib/apt/lists/*

# Run entrypoint script
COPY docker-scripts/docker-entrypoint.sh /root/scripts/entrypoint.sh
RUN chmod +x /root/scripts/entrypoint.sh

# Install Jekyll
RUN gem update --system && gem install jekyll && gem cleanup

# Set the default server at https://localhost:4000
EXPOSE 4000

# After go into docker, set the working directory at /site
WORKDIR /site

# Copy Gemfile into docker's /site/Gemfile
COPY Gemfile /site/Gemfile

# Use the above image as base for building the jekyll-serve
FROM jekyll AS jekyll-serve

# Everytime the container starts, it will run the entrypoint script
ENTRYPOINT ["/root/scripts/entrypoint.sh"]

# After run entrypoint.sh, run this command "bundle exec jekyll serve"
CMD ["bundle", "exec", "jekyll", "serve"]

