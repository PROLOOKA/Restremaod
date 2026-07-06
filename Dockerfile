# استخدام الصورة الرسمية لـ Restreamer
FROM datarhei/restreamer:latest

# تعيين المنفذ الافتراضي (غالباً ما تستخدم Railway المنفذ 8080)
ENV PORT=8080

# إخبار Docker أن الحاوية ستستخدم هذا المنفذ
EXPOSE 8080
