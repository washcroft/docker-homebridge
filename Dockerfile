FROM jrottenberg/ffmpeg:7.1-vaapi2404 AS ffmpeg

FROM homebridge/homebridge:ubuntu

# Bluetooth Support
RUN apt-get update \
  && apt-get install -y bluetooth bluez libbluetooth-dev libudev-dev libcap2-bin rsyslog \
  && setcap cap_net_admin,cap_net_raw,cap_net_bind_service=+eip $(eval readlink -f `which node`) \
  && setcap cap_net_admin,cap_net_raw,cap_net_bind_service=+eip $(eval readlink -f `which hcitool`) \
  && setcap cap_net_admin,cap_net_raw,cap_net_bind_service=+eip $(eval readlink -f `which hciconfig`)

# FFmpeg w/VAAPI Support
RUN apt-get install -y --no-install-recommends libva-drm2 libva2 i965-va-driver vainfo
ENV LD_LIBRARY_PATH=/usr/local/lib
COPY --from=ffmpeg /usr/local /usr/local
COPY --from=ffmpeg /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu

COPY rootfs /

COPY ffmpeg-wrapper.sh /usr/local/bin/ffmpeg-wrapper.sh
RUN chmod +x /usr/local/bin/ffmpeg-wrapper.sh