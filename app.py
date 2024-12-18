from flask import Flask
import logging

app = Flask(__name__)

@app.route('/')
def hello_world():
    logging.warning("hello world log message")
    return 'Hello World'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
