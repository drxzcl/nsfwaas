FROM ubuntu:14.04
MAINTAINER drxzclx@gmail.com

# Based on CAFFE's CPU container

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        wget \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-pip \
        python-scipy \
	cython \
	python-skimage \
	python-matplotlib \
	ipython \
	python-h5py \
	python-leveldb \
	python-networkx \
	python-nose \
	python-pandas \
	python-dateutil \
	python-protobuf \
	python-gflags \
	python-yaml \
	python-pil \
	python-six \
	python-flask && \
    rm -rf /var/lib/apt/lists/*

ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT

# FIXME: clone a specific git tag and use ARG instead of ENV once DockerHub supports this.
ENV CLONE_TAG=master

RUN git clone -b ${CLONE_TAG} --depth 1 https://github.com/BVLC/caffe.git . && \
    for req in $(cat python/requirements.txt) pydot; do pip install $req; done && \
    mkdir build && cd build && \
    cmake -DCPU_ONLY=1 .. && \
    make -j"$(nproc)"

ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

WORKDIR /workspace

RUN git clone https://github.com/yahoo/open_nsfw.git

COPY nsfwnet.py /workspace/
COPY nsfwaas.py /workspace/

# Expose the webserver
EXPOSE 5000

CMD ["/usr/bin/python","nsfwaas.py"]
