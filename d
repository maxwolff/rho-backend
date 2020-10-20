# The elixir base image is currently based on Debian 9 "Stretch" and can
# be used to build OTP releases with a Stretch-compatible ERTS.
FROM elixir:latest


##############################################################################
## Build arguments. Modify these to adapt this Dockerfile to your app.      ##
## Alternatively, you may specify --build-arg when running `docker build`.  ##

## The build environment. This is usually prod, but you might change it if  ##
## you have staging environments.                                           ##
ARG build_env=prod

ARG app_name=rho
ARG network=kovan

## End build arguments.                                                     ##
##############################################################################


# Set up the build environment.
ENV MIX_ENV=${build_env} \
	NETWORK=network \
    TERM=xterm
WORKDIR /app

# Additional installations needed for building (hex, rebar).
RUN mix local.rebar --force && mix local.hex --force

# Copy the application in. Note that you should generally use a .dockerignore
# file to omit build artifacts from your development environment (e.g. the
# "_build" and "deps" directories, as well as "assets/node_modules" and
# "priv/static" for assets).
COPY . .

# Compile the Elixir app.
RUN mix do deps.get, compile

# Create the release using distillery.
RUN mix release

# Move the standalone executable to a well-known location so it can be copied
# out of the image.
RUN mv _build/${build_env}/rel/${app_name}/bin/${app_name} /app/start_release
