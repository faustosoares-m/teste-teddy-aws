import os
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)


def get_db_connection():
    """Create a one-off PostgreSQL connection for health-style checks."""
    return psycopg2.connect(
        dbname=os.getenv("POSTGRES_DB", "demo"),
        user=os.getenv("POSTGRES_USER", "demo"),
        password=os.getenv("POSTGRES_PASSWORD", "YOUR_POSTGRES_PASSWORD"),
        host=os.getenv("POSTGRES_HOST", "postgres"),
        port=int(os.getenv("POSTGRES_PORT", "5432")),
    )


@app.route("/")
def health():
    return jsonify({"status": "ok"})


@app.route("/db_test")
def db_test():
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
                result = cur.fetchone()
        return jsonify({"db_result": result[0], "status": "ok"})
    except Exception as exc:
        return jsonify({"status": "error", "message": str(exc)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
