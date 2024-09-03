FROM rockylinux:9.3.20231119

ENV AST_VERSION=20

RUN dnf -y install epel-release && \
    dnf group -y install "Development Tools" && \
    dnf -y install libedit-devel sqlite-devel psmisc gmime-devel \
    ncurses-devel sox newt-devel libxml2-devel libtiff-devel \
    audiofile-devel gtk2-devel libtool libuuid-devel subversion \
    kernel-devel kernel-devel git kernel-devel crontabs cronie \
    cronie-anacron chkconfig initscripts wget

RUN echo "The version of asterisk is ${AST_VERSION}"
RUN cd /usr/src/ && \
    wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${AST_VERSION}-current.tar.gz && \
    for n in `ls *.tar.gz`; do tar xfvz $n; done && \
    rm -rf *.tar.gz

RUN cd /usr/src/asterisk* && \
    contrib/scripts/install_prereq install && \
    ./configure --libdir=/usr/lib64 --with-jansson-bundled=yes && \
    make && \
    make install && \
    make samples && \
    make config && \
    ldconfig

CMD ["sleep","infinity"]    
#CMD [ "asterisk","-f" ]