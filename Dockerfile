# mbuckler/tf-faster-rcnn-deps
#
# Dockerfile to hold dependencies for the Tensorflow implmentation
# of Faster RCNN

FROM nvidia/cuda:9.0-cudnn7-devel
WORKDIR /root

# Get required packages
RUN apt-get update && \
  apt-get install vim \
                  python-pip \
                  python-dev \
                  python-opencv \
                  python-tk \
                  libjpeg-dev \
                  libfreetype6 \
                  libfreetype6-dev \
                  zlib1g-dev \
                  cmake \
                  wget \
                  cython \
                  git \
                  -y
                  
# Get required python modules
RUN pip install --upgrade pip
RUN pip install image \
                scipy \
                matplotlib \
                PyYAML \
                numpy \
                easydict \
                tensorflow-gpu
# Update numpy
RUN pip install -U numpy

# Install python interface for COCO
RUN mkdir /anaconda
ADD cnn-aw-model.h5 .
ADD conda.tar.gz /
ADD run.py /root/run.py

# Add CUDA to the path
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda/lib64
ENV CUDA_HOME /usr/local/cuda
ENV PYTHONPATH /root/coco/PythonAPI
ENTRYPOINT ["/anaconda/envs/py35/bin/python"]
CMD "run.py"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install libcuda1-396 nvidia-396-dev -y
ENTRYPOINT ["/anaconda/envs/py35/bin/python","run.py"]
