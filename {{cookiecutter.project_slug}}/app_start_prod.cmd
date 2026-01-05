@echo off

if "%1"=="force" (
    docker compose -f compose-prod.yml build --no-cache
)

docker compose -f compose-prod.yml up --build --force-recreate