# Download base image ubuntu 16.04
FROM ubuntu:16.04
MAINTAINER Taehyoung Yim <yim0823@naver.com>

# Run upgrades
RUN apt-get update

# Install basic packages
RUN apt-get -qq -y install git curl build-essential

# Create src directory and move to src directory
#RUN mkdir src
#WORKDIR /src

# Clone git repository
RUN git clone https://github.com/yim0823/kakaopay.git
