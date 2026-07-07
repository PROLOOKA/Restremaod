FROM flussonic/flussonic:latest

# منفذ واجهة Flussonic
EXPOSE 80

# منفذ RTMP
EXPOSE 1935

# منفذ RTMPS (اختياري)
EXPOSE 1936

# منفذ SRT
EXPOSE 6000/udp

ENV PORT=80
