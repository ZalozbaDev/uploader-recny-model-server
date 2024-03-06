FROM node:20.11.1-bookworm
MAINTAINER Daniel Sobe <daniel.sobe@sorben.com>

# docker build -f docker/Dockerfile -t offline_transcription_back .
# docker build -f docker/Dockerfile -t offline_transcription_back . --no-cache

RUN apt update

RUN apt install -y sox ffmpeg python3 python3-numpy

RUN git clone https://github.com/ZalozbaDev/whisper.cpp.git

RUN cd whisper.cpp && git checkout v1.5.2

RUN cd whisper.cpp && make

RUN apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev

RUN wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz

RUN tar xvfz Python-3.10.0.tgz

RUN cd Python-3.10.0 && ./configure --enable-optimizations && make -j8 && make altinstall

RUN git clone https://github.com/ZalozbaDev/fairseq

RUN cd fairseq && git checkout e4cebef3bb4e24e08c001d874e88e3bd78295a28

RUN cd fairseq && python3.10 -m venv .

RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install wheel==0.42.0'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install cython==3.0.8'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install soundfile==0.12.1'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install editdistance==0.8.1'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install torch==2.2.1'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install hydra-core==1.0.7'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install numpy==1.26.4'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install omegaconf==2.0.6'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install regex==2023.12.25'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install sacrebleu==2.4.0'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install scipy==1.12.0'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install scikit-learn==1.4.1post1'
RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install torchaudio==2.2.1'

RUN cd fairseq && /bin/bash -c 'source bin/activate && pip install --editable ./'

RUN git clone https://github.com/ZalozbaDev/uploader-recny-model-server

RUN cd uploader-recny-model-server && git checkout main

RUN cd uploader-recny-model-server && mkdir -p uploads && npm install

COPY docker/startme.sh /

RUN mkdir -p /proprietary

RUN mkdir -p /whisper

RUN mkdir -p /fairseqdata

CMD ["/bin/bash", "-c", "/startme.sh"] 
