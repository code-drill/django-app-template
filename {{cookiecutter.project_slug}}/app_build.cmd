docker compose build
IF "%1"=="prod" (
    docker build -f Dockerfile --tag {{cookiecutter.project_slug}}:prod .
) ELSE (
    docker build -f Dockerfile-dev --tag {{cookiecutter.project_slug}}:dev .
)