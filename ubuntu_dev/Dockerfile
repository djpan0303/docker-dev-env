FROM ubuntu:22.10
#add user&group for pan and grant sudo privilege to pan
RUN groupadd -r pan && useradd -r -g pan pan && echo 'pan ALL=(ALL)   NOPASSWD:ALL' >> /etc/sudoers
#install locate command
RUN apt update && apt install locate -y && updatedb \
    && apt install vim -y \
    && apt install -y sudo \
    && apt install -y git \
    && apt install -y cmake
#install bazel
RUN apt update && apt install apt-transport-https curl gnupg -y \
    && /bin/sh -c "curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg" \
    && mv bazel-archive-keyring.gpg /usr/share/keyrings \
    && /bin/sh -c  "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8\" | tee /etc/apt/sources.list.d/bazel.list" \
    && apt update && apt install bazel-5.3.2 -y && ln -s /usr/bin/bazel-5.3.2 /usr/bin/bazel

#install cgal lib
RUN apt update && apt install libcgal-dev -y

# for cyber
#RUN apt update && apt install qtbase5-dev

USER pan
WORKDIR /home/pan
