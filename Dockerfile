# Copyright 2017-2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

# For more information on creating a Dockerfile
# https://docs.docker.com/compose/gettingstarted/#step-2-create-a-dockerfile
# https://github.com/awslabs/amazon-sagemaker-examples/master/advanced_functionality/pytorch_extending_our_containers/pytorch_extending_our_containers.ipynb
ARG REGION=us-west-2

# SageMaker PyTorch image
FROM 763104351884.dkr.ecr.$REGION.amazonaws.com/pytorch-training:1.13.1-gpu-py39-cu117-ubuntu20.04-sagemaker-v1.0 

ENV PATH="/opt/ml/code:${PATH}"

# Install MMDetection
WORKDIR /opt/ml/code
RUN pip install mmcv-full==1.7.0 -f https://download.openmmlab.com/mmcv/dist/cu117/torch1.13/index.html
RUN git clone https://github.com/hiroki-mtg/mmdetection
RUN cd mmdetection/ && \
    pip install -e .

# Address https://github.com/pytorch/pytorch/issues/37377
ENV MKL_THREADING_LAYER GNU
ENV MMDETECTION /opt/ml/code/mmdetection

# Sagemaker Config
COPY /mmdetection /opt/ml/code
ENV SAGEMAKER_SUBMIT_DIRECTORY /opt/ml/code
ENV SAGEMAKER_PROGRAM main.py
