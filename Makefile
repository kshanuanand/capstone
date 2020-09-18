setup:
	python -m venv ~/.devops
	source ~/.devops/bin/activate
	echo 'R3QxNXRvMTlHdWl0YXIkCg==' | base64 --decode | docker login -u kshanuanand --password-stdin

install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt
	wget -O /bin/hadolint "https://github.com/hadolint/hadolint/releases/download/v1.18.0/hadolint-Linux-x86_64" &&\
		chmod +x /bin/hadolint
	wget https://github.com/htacg/tidy-html5/releases/download/5.4.0/tidy-5.4.0-64bit.rpm &&\
		yum install -y ./tidy-5.4.0-64bit.rpm

lint:
	hadolint Dockerfile
	pylint --disable=R,C,W1203 app.py
	tidy templates/*.html

all: install lint