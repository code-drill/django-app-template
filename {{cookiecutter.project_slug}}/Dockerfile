FROM bitnami/minideb:bookworm
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ARG userid=1000
ARG groupid=1000

RUN install_packages dos2unix
COPY app/bin/*.bsh /usr/local/bin/
RUN dos2unix /usr/local/bin/*.bsh
RUN chmod +x /usr/local/bin/*.bsh

RUN group_init.bsh $groupid
RUN user_init.bsh $userid $groupid

WORKDIR /app
RUN chown -R $userid:$groupid /app

RUN env_vars_init.bsh $userid
USER $userid

COPY pyproject.toml /app/pyproject.toml
RUN . /etc/environment && uv sync
RUN mkdir -p /tmp/prometheus-multiproc-dir/celery-worker
RUN chown -R $userid:$groupid /tmp/prometheus-multiproc-dir/celery-worker /tmp/prometheus-multiproc-dir

## BEGIN for pycharm to use interpretator form Docker image/Dockerfile
ENV PATH="/home/app_user/venv/bin:$PATH"
ENV VIRTUAL_ENV="/home/app_user/venv"
ENV HOME="/home/app_user"
## END
