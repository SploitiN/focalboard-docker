# syntax=docker/dockerfile:1

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    build-essential \
    software-properties-common \
    ca-certificates \
    libssl-dev \
    pkg-config \
    gnupg \
    lsb-release \
    python3 \
    python3-pip \
    nodejs \
    npm

# Install Go (required for backend)
RUN wget https://go.dev/dl/go1.20.7.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.20.7.linux-amd64.tar.gz && \
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

ENV PATH="/usr/local/go/bin:${PATH}"

# Clone Focalboard
RUN git clone https://github.com/mattermost/focalboard.git /focalboard

WORKDIR /focalboard

# Build frontend
FROM mattermost/focalboard:latest

# Build backend
WORKDIR /focalboard/server
RUN go build

# Expose port
EXPOSE 8000

# Run the damn thing
CMD ["./focalboard"]
