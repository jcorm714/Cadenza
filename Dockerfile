FROM ubuntu:18.04

ENV LANG C.UTF-8

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y python3-numpy python3-six \
       libfftw3-3 libyaml-0-2 libtag1v5 libsamplerate0 python3-yaml \
       libavcodec57 libavformat57 libavutil55 libavresample3 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y build-essential python3-dev git \
    libfftw3-dev libavcodec-dev libavformat-dev libavresample-dev \
    libsamplerate0-dev libtag1-dev libyaml-dev \
    && mkdir /essentia && cd /essentia && git clone https://github.com/MTG/essentia.git \
    && cd /essentia/essentia && git checkout v2.1_beta5 && python3 waf configure --with-python --with-examples --with-vamp \
    && python3 waf && python3 waf install && ldconfig \
    &&  apt-get remove -y build-essential libyaml-dev libfftw3-dev libavcodec-dev \
        libavformat-dev libavutil-dev libavresample-dev python-dev libsamplerate0-dev \
        libtag1-dev python-numpy-dev \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && cd / && rm -rf /essentia/essentia


ENV PYTHONPATH /usr/local/lib/python3/dist-packages

WORKDIR /essentia

RUN ["mkdir", "music"]
RUN ["mkdir", "audio"]

COPY Audio/Flight.mp3 music/

RUN ["cp", "music/Flight.mp3", "audio/complex.mp3"]
RUN ["cp", "music/Flight.mp3", "audio/hfc.mp3"]

COPY detect_onsets.py .

RUN ["python3", "detect_onsets.py"]
