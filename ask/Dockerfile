FROM python:3.12-alpine
WORKDIR /app
RUN apk add --no-cache curl
COPY app.py /app/app.py
RUN pip install --no-cache-dir flask
ENV PYTHONUNBUFFERED=1
EXPOSE 8080
CMD ["python", "app.py"]


