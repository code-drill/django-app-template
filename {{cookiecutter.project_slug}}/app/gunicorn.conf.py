import multiprocessing
from pathlib import Path

import environ

{% if cookiecutter.use_prometheus == "y" %}
from prometheus_client import multiprocess
{% endif %}

ROOT_DIR = Path(__file__).resolve().parent.parent
env = environ.Env(DEBUG=(bool, False))
env_file_path = ROOT_DIR / ".env"
if env_file_path.is_file():
    env.read_env(env_file_path, overwrite=True)

GUNICORN_MAX_WORKERS = env("GUNICORN_MAX_WORKERS", cast=int, default=0)

workers = 2 * multiprocessing.cpu_count() + 1
if 0 < GUNICORN_MAX_WORKERS < workers:
    workers = GUNICORN_MAX_WORKERS

bind = "0.0.0.0:8000"
wsgi_app = "core.asgi:application"
access_logfile = "-"
worker_class = "uvicorn.workers.UvicornWorker"


{% if cookiecutter.use_prometheus == "y" %}
_prometheus_multiproc_dir = env("PROMETHEUS_MULTIPROC_DIR", default=None)

def child_exit(server, worker):
    if _prometheus_multiproc_dir:
        multiprocess.mark_process_dead(worker.pid)
{% endif %}
