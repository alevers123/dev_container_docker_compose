FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
   neovim \
   zsh \
   tmux \
   git \
   wget\
   curl\
   sudo\
   locales\
   build-essential\
   iproute2\
   unzip\
   vifm \
   gtkwave
ARG uname
ARG uid
ARG gid
ARG docker_guid
#RUN mkdir /home/$uname
#VOLUME /home/$uname
COPY ./scripts /opt/scripts
RUN locale-gen en_US.UTF-8
RUN userdel ubuntu
RUN addgroup --gid $gid $uname && addgroup --gid $docker_guid docker
RUN adduser --gecos "" --home /home/$uname --shell /bin/zsh --uid $uid --gid $gid $uname && adduser \
$uname sudo && adduser $uname docker && passwd -d $uname && chown -R $uname:$uname /home/$uname && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
/etc/sudoers
RUN wget "https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip" && unzip win32yank-x64.zip && mkdir /opt/win_executables && mv win32yank.exe /opt/win_executables/
ENV PATH="$PATH:/opt/win_executables:/opt/windows"
USER $uname
RUN bash /opt/scripts/setup.sh $uname
WORKDIR /home/$uname
ENTRYPOINT ["/bin/zsh"]
