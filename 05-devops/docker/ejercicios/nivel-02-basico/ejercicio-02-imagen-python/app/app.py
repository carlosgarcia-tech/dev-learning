"""app.py — API mínima con Flask que sirve / y /health."""
import os
from flask import Flask, jsonify

app = Flask(__name__)
PORT = int(os.environ.get("PORT", 5000))


@app.get("/")
def root():
    return jsonify(ok=True, service="python")


@app.get("/health")
def health():
    return jsonify(ok=True)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT)
