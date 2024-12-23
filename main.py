from flask import Flask
import logging

app = Flask(__name__)

@app.route('/')
def warning():
    logging.warning("Warning message")
    return 'Warning message'

@app.route('/api')
def info():
    logging.info("API log message")
    return 'API log message'

@app.route('/error')
def error():
    logging.error("Error log message")
    return 'Error !!!!!'

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000) #, debug=True, use_reloader=False)
