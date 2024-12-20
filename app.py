from flask import Flask
import logging

app = Flask(__name__)

@app.route('/')
def warning():
    logging.warning("Warning message")
    return 'Warning message'

@app.route('/info')
def info():
    logging.info("Info log message")
    return 'Info log message'

@app.route('/error')
def error():
    logging.error("Error log message")
    return 'Error !!!!!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
