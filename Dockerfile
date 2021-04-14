FROM article714/debian-based-container:0.8.0
LABEL maintainer="C. Guychard <Article714>"



# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

# Container tooling

COPY container /container

# container building

RUN /container/build.sh

WORKDIR /home/nginx

# port exposed (default)

EXPOSE 8080
