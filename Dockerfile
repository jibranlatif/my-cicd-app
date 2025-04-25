FROM python:3.9-slim

WORKDIR /app

# First copy only requirements to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Then copy the rest of the application
COPY . .

ENV FLASK_APP=app.py
ENV FLASK_ENV=development

EXPOSE 5000

CMD ["flask", "run", "--host", "0.0.0.0"]
