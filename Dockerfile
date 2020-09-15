FROM python:3.5-alpine

WORKDIR /app/

COPY requirements.txt app.py /app/

RUN pip install --upgrade pip &&\
        pip install -r requirements.txt

EXPOSE 5000

CMD ['python3', 'app.py']
