FROM python:3.8-slim

ENV USER=optimal HOME=/home/optimal TZ=Asia/Tokyo
RUN export gid=1000 pswd=optimal && \
    apt-get update --fix-missing && apt-get install -y --no-install-recommends tzdata busybox wget fonts-ipaexfont && \
    groupadd -g $gid $USER && \
    useradd -g $USER -m -s /bin/bash $USER && \
    echo "$USER:$pswd" | chpasswd && \
    /bin/busybox --install

RUN pip install --no-cache pandas matplotlib jupyter more-itertools
RUN pip install --no-cache scipy networkx ortoolpy yapf jupyter-contrib-nbextensions
RUN jupyter contrib nbextension install --user
RUN jupyter nbextensions_configurator enable --user
COPY jupyter_notebook_config.py $HOME/.jupyter/
ADD nbconfig.tgz $HOME/.jupyter/
RUN export uid=1000 gid=1000 && \
    chown ${uid}:${gid} -R $HOME /usr/local/lib/python3.8/site-packages

USER $USER
WORKDIR $HOME
CMD ["/usr/local/bin/jupyter-notebook", "--ip=0.0.0.0"]
