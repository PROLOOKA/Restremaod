FROM --platform=linux/amd64 ubuntu:22.04

# إعداد المتغيرات الأساسية
ENV DEBIAN_FRONTEND=noninteractive
ENV STREAM_URL="http://162.212.156.99:5295/Felsl/index.m3u8"

# تثبيت الحزم الأساسية و Python 3.11
RUN apt update -y && apt install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt update -y && apt install -y \
    openssh-server \
    sudo \
    vim \
    net-tools \
    curl \
    wget \
    git \
    tzdata \
    ffmpeg \
    nginx \
    python3.11 \
    python3.11-dev \
    python3.11-distutils \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# تثبيت pip ومكتبات Python المطلوبة
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 && \
    python3.11 -m pip install --upgrade pip setuptools wheel

RUN python3.11 -m pip install --no-cache-dir \
    mtranslate google-genai requests g4f mutagen tgcalls==3.0.0.dev6 \
    py-tgcalls~=2.2.11 telethon aiosqlite aiocron emoji pytz gtts \
    qrcode Telegram aiohttp fake_useragent user_agent hijri_converter \
    gpytranslate watchdog

# إعداد المجلدات والمستودع
WORKDIR /root
RUN git clone https://github.com/2mrxe2/pro

# إعداد SSH
RUN mkdir -p /var/run/sshd
RUN echo "root:final1997@@@" | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# إنشاء مجلد البث
RUN mkdir -p /var/www/html/hls

# إنشاء ملف إعدادات Nginx مباشرة من داخل Dockerfile
RUN echo 'worker_processes 1; \
events { worker_connections 1024; } \
http { \
    include mime.types; \
    default_type application/octet-stream; \
    sendfile on; \
    server { \
        listen 80; \
        location /hls { \
            root /var/www/html; \
            add_header Access-Control-Allow-Origin *; \
            add_header Cache-Control no-cache; \
        } \
        location / { \
            root /var/www/html; \
            index index.html; \
        } \
    } \
}' > /etc/nginx/nginx.conf

# إنشاء سكربت التشغيل مباشرة من داخل Dockerfile
RUN echo '#!/bin/bash \n\
/usr/sbin/sshd \n\
nginx \n\
ffmpeg -i "${STREAM_URL}" \
       -c:v copy -c:a aac -ar 48000 -b:a 128k \
       -f hls -hls_time 10 -hls_list_size 6 -hls_flags delete_segments \
       /var/www/html/hls/index.m3u8 \n\
wait' > /usr/local/bin/start.sh && chmod +x /usr/local/bin/start.sh

# فتح المنافذ المطلوبة
EXPOSE 22 80

# تشغيل السكربت عند بدء الحاوية
CMD ["/usr/local/bin/start.sh"]
