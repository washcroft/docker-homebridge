ARG IMAGE_TAG
FROM oznu/homebridge:${IMAGE_TAG:-ubuntu}

# Bluetooth Support
RUN apt-get update \
  && apt-get install -y bluetooth bluez libbluetooth-dev libudev-dev libcap2-bin rsyslog \
  && setcap cap_net_admin,cap_net_raw,cap_net_bind_service=+eip $(eval readlink -f `which node`) \
  && setcap cap_net_admin,cap_net_raw,cap_net_bind_service=+eip $(eval readlink -f `which hcitool`) \
  && setcap cap_net_admin,cap_net_raw,cap_net_bind_service=+eip $(eval readlink -f `which hciconfig`)

# FFmpeg Packages
RUN apt-get install -y libass-dev libfreetype6-dev libgnutls28-dev libmp3lame-dev libsdl2-dev \
    libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev \
    libunistring-dev libx264-dev libx265-dev libnuma-dev libvpx-dev libfdk-aac-dev libopus-dev \
    libspeex-dev libsndio-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev librtmp-dev \
    openssl libssl-dev vainfo

COPY root /
COPY ffmpeg-custom /usr/local/bin/ffmpeg-custom
COPY ffmpeg.sh /usr/local/bin/ffmpeg.sh
RUN chmod +x /usr/local/bin/ffmpeg.sh && chmod +x /usr/local/bin/ffmpeg-custom