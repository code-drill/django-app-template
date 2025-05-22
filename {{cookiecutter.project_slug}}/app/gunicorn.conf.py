import multiprocessing

{% if cookiecutter.use_prometheus == "y" %}
from prometheus_client import multiprocess
{% endif %}

workers = 2 * multiprocessing.cpu_count() + 1
bind = "0.0.0.0:8000"
wsgi_app = "core.asgi:application"
access_logfile = "-"
worker_class = "uvicorn.workers.UvicornWorker"


{% if cookiecutter.use_prometheus == "y" %}
def child_exit(server, worker):
    multiprocess.mark_process_dead(worker.pid)
{% endif %}
