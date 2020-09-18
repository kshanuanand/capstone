setup:
	python3 -m venv .devops
	echo 'R3QxNXRvMTlHdWl0YXIkCg==' | base64 --decode | docker login -u kshanuanand --password-stdin

install:
	pip3 install --upgrade pip &&\
		pip3 install -r requirements.txt
	#wget -O hadolint "https://github.com/hadolint/hadolint/releases/download/v1.18.0/hadolint-Linux-x86_64" &&\
	#	chmod +x hadolint
	#wget https://github.com/htacg/tidy-html5/releases/download/5.4.0/tidy-5.4.0-64bit.rpm &&\
	#	yum install -y ./tidy-5.4.0-64bit.rpm

lint:
	hadolint --ignore DL3013 Dockerfile
	pylint --disable=R,C,W1203 app.py
	jinja-ninja templates/index.html
	tidy templates/aboutme.html

all: install lint