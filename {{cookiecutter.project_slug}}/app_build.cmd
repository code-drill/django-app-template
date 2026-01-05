@echo off
IF "%1"=="prod" (
    call :process_prod
) ELSE (
    IF "%1"=="both" (
        echo "Building both prod and dev images..."
        call :process_prod
        call :process_dev
    ) ELSE (
        call :process_dev
    )
)
call :process_backup
exit /b

:process_prod
docker build -f Dockerfile --tag {{cookiecutter.project_slug}}:prod --target prod .
exit /b

:process_dev
docker build -f Dockerfile --tag {{cookiecutter.project_slug}}:dev --target dev .
exit /b

:process_backup
cd backups
docker build -f Dockerfile --tag {{cookiecutter.project_slug}}-backup .
cd ..
exit /b
