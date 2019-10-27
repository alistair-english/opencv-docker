FROM ubuntu:16.04

# install deps
RUN apt-get update && apt-get install -y \
    # compiler
    build-essential \
    # required
    cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev \
    # optional
    libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev \
    # for getting source
    curl

ARG OPENCV_VERSION="4.1.1"
ENV OPENCV_VERSION $OPENCV_VERSION

RUN curl -sL https://github.com/Itseez/opencv/archive/${OPENCV_VERSION}.tar.gz | tar xvz -C /tmp
RUN mkdir -p /tmp/opencv-${OPENCV_VERSION}/build

WORKDIR /tmp/opencv-${OPENCV_VERSION}/build

RUN cmake \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D CMAKE_BUILD_TYPE=RELEASE \
-D BUILD_DOCS=OFF \
-D BUILD_EXAMPLES=OFF \
-D BUILD_TESTS=OFF \
-D BUILD_PERF_TESTS=OFF \
-D BUILD_opencv_java=NO \
-D BUILD_opencv_python=NO \
-D BUILD_opencv_python2=NO \
-D BUILD_opencv_python3=NO \
..

RUN make -j $(nproc --all) && make install

# cleanup
RUN apt-get autoclean && apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /