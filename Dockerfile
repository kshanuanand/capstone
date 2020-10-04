FROM python:3.5-alpine

WORKDIR /app/

COPY . app.py /app/

RUN pip3 install --upgrade pip &&\
	pip3 install -r requirements.txt
echo "Show Linting Error"
EXPOSE 5000

CMD ["python3", "app.py"] 
