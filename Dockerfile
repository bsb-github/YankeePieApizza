# Flutter Web Docker Example Dockerfile

# Stage 1: Install dependencies and build Flutter app
FROM debian:latest AS build-env
RUN apt-get update && apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 psmisc && apt-get clean

ARG FLUTTER_SDK=/usr/local/flutter
ARG FLUTTER_VERSION=3.22.0

# Clone Flutter
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK

# Switch to the desired Flutter version
RUN cd $FLUTTER_SDK && git fetch && git checkout $FLUTTER_VERSION

# Set Flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Copy the app files
COPY . /app/
WORKDIR /app/

# Get app dependencies
RUN flutter pub get

# Build the app for the web
RUN flutter build web --web-renderer html --release

# Stage 2: Serve the built app using Nginx
FROM nginx:latest

# Copy the built web content from the previous stage
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for incoming web traffic
EXPOSE 80




