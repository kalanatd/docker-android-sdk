FROM ubuntu:22.04


ENV ANDROID_SDK_HOME /opt/android-sdk-linux
ENV ANDROID_SDK_ROOT /opt/android-sdk-linux
ENV ANDROID_HOME /opt/android-sdk-linux
ENV ANDROID_SDK /opt/android-sdk-linux
ENV SYSTEM_IMAGE="system-images;android-34-ext12;google_apis_playstore;x86_64"
ENV ANDROID_PLATFORM_API="platforms;android-34"

ENV PATH $PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin/:$ANDROID_HOME/build-tools/35.0.0/:$ANDROID_HOME/emulator/:$ANDROID_HOME/bin:/opt/tools

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && apt-get update -yqq && apt-get install -y \
  curl \
  expect \
  git \
  libarchive-tools \
  locales \
  make \
  openjdk-17-jdk \
  openssh-client \
  unzip \
  vim \
  wget \
  zip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.UTF-8

RUN groupadd android && useradd -d /opt/android-sdk-linux -g android -u 1000 android

COPY tools /opt/tools

COPY licenses /opt/licenses

RUN sdkmanager --install "$SYSTEM_IMAGE" "$ANDROID_PLATFORM_API" "platform-tools" "emulator" "platforms"


WORKDIR /opt/android-sdk-linux

CMD entrypoint.sh built-in
