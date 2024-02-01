# Broken since jrottenberg/ffmpeg uses Ubuntu 20.04 and homebridge/homebridge uses Ubuntu 22.04
#FROM jrottenberg/ffmpeg:4.1-vaapi as ffmpeg

FROM homebridge/homebridge:ubuntu

# Bluetooth Support
RUN apt-get update \
  && apt-get install -y bluetooth bluez libbluetooth-dev libudev-dev libcap2-bin rsyslog \
  && setcap cap_net_admin,cap_net_raw,cap_net_bind_service=+eip $(eval readlink -f `which node`) \
  && setcap cap_net_admin,cap_net_raw,cap_net_bind_service=+eip $(eval readlink -f `which hcitool`) \
  && setcap cap_net_admin,cap_net_raw,cap_net_bind_service=+eip $(eval readlink -f `which hciconfig`)

COPY rootfs /

# FFmpeg w/VAAPI Support
#ENV LD_LIBRARY_PATH=/usr/local/lib
#COPY --from=ffmpeg /usr/local /usr/local
#COPY --from=ffmpeg /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu

COPY ffmpeg-wrapper.sh /usr/local/bin/ffmpeg-wrapper.sh
RUN chmod +x /usr/local/bin/ffmpeg-wrapper.sh