FROM ubuntu:22.10
RUN apt update && apt install apt-transport-https curl gnupg -y \
    && /bin/sh -c "curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor >bazel-archive-keyring.gpg" \
    && mv bazel-archive-keyring.gpg /usr/share/keyrings \
    && /bin/sh -c  "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8\" | tee /etc/apt/sources.list.d/bazel.list" \
    && apt update && apt install bazel -y

RUN apt update && apt install libcgal-dev -y
#ENTRYPOINT ["/bin/bash"]