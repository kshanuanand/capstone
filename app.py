import socket
from random import randint
from flask import Flask, render_template
app = Flask(__name__)

colors = {
1:'#F0F8FF',
2:'#7FFFD4',
3:'#F0FFFF',
4:'#6495ED',
5:'#00CED1'
}

colorInd = randint(1,5)

@app.route('/')
def hello_world():
    myHostname=socket.gethostname()
    return render_template("index.html", podname=myHostname, bgcolor=colors[colorInd])

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
