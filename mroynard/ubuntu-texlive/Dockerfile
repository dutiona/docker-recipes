FROM ubuntu:bionic
LABEL maintainer="Michaël Roynard <mroynard@lrde.epita.fr>"

ENV container docker
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install all pkg
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN apt-get update && apt-get dist-upgrade -y && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential binutils git ninja-build cmake bear python python3 python-pip python3-pip \
    texlive-full htmldoc
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y && rm -rf /var/lib/apt/lists/

# Install python packages
RUN echo y | pip install -U pip
RUN echo y | pip install -U six wheel setuptools
RUN echo y | pip install sphinx breathe exhale sphinx_rtd_theme
RUN echo y | pip3 install -U pip
RUN echo y | pip3 install -U six wheel setuptools
RUN echo y | pip3 install conan sphinx breathe exhale sphinx_rtd_theme

WORKDIR /workspace

CMD ["/bin/bash"]
