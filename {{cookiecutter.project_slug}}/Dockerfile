FROM python:3.12-slim-bookworm AS base
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ARG userid=1000
ARG groupid=1000

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    libpcre3 \
    libxml2 \
    dos2unix \
    fd-find \
    curl \
    gnupg \
    ca-certificates \
    libicu72 \
    libvpx7 \
    libavif15  \
    libjpeg62-turbo  \
    && rm -rf /var/lib/apt/lists/*

ENV UV_PYTHON=3.12 \
    PYTHONPATH="/app/app/src:." \
    DJANGO_SETTINGS_MODULE="core.settings" \
    UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PYTHON=python3.12 \
    UV_TOOL_BIN_DIR=/usr/local/bin

COPY --chmod=0755 app/bin/*.bsh /usr/local/bin/
COPY --chmod=0755 app/*.bsh /usr/local/bin/

RUN find /usr/local/bin/ -name "*.bsh" -exec dos2unix {} \; && \
    group_init.bsh $groupid && \
    user_init.bsh $userid $groupid

RUN env_vars_init.bsh $userid

WORKDIR /app

{% if cookiecutter.use_playwright == "y" %}
RUN --mount=type=cache,target=/root/.cache \
    --mount=type=bind,source=uv.lock,target=/tmp/uv.lock \
    playwright_version=$(awk '/^\[\[package\]\]/{p=0} /name = "playwright"/{p=1} p && /^version = /{print $3; exit}' /tmp/uv.lock | tr -d '"') && \
    uv venv && uv pip install playwright==$playwright_version
{% else %}
RUN --mount=type=cache,target=/root/.cache \
    --mount=type=bind,source=uv.lock,target=/tmp/uv.lock
{% endif %}

ENV PATH="/app/.venv/bin:$PATH"

RUN --mount=type=cache,target=/root/.cache \{% if cookiecutter.use_playwright == "y" %}
    playwright install-deps && \
    playwright install && \{% endif %}
    cp -R /root/.cache /home/app_user/.cache &&  \
    chown -R $userid:$groupid /home/app_user/.cache

RUN --mount=type=cache,target=/root/.cache \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync \
        --locked \
        --no-install-project

RUN mkdir -p /app/app/src/uploads && \
    chmod +777 /app/app/src/uploads

USER $userid

RUN mkdir -p /tmp/prometheus-multiproc-dir/celery-worker && \
    chown -R $userid:$groupid /tmp/prometheus-multiproc-dir/celery-worker /tmp/prometheus-multiproc-dir


# Development stage
FROM base AS dev
COPY --from=base --chown=app_user:app_user /app/.venv /app/.venv

# Production stage
FROM base AS prod

COPY app /app/app
COPY --from=base --chown=app_user:app_user /app/.venv /app/.venv

CMD ["entrypoint.bsh"]
