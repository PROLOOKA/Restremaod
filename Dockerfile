FROM datarhei/restreamer:latest

# فتح منافذ البث:
# 1935: RTMP (الذي تحتاجه الآن)
# 8080: واجهة التحكم (المتصفح)
# 6000: SRT (للبث بجودة عالية)
EXPOSE 8080 1935 1936 6000/udp

# تعريف المنفذ لـ Railway
ENV PORT=8080
