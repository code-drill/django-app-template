@echo off
call :process_prod
call :process_backup
exit /b

:process_prod
docker build -f Dockerfile --tag {{cookiecutter.project_slug}}:prod --target prod .
docker tag {{cookiecutter.project_slug}}:prod {{cookiecutter.docker_registry}}/{{cookiecutter.project_slug}}:prod
docker push {{cookiecutter.docker_registry}}/{{cookiecutter.project_slug}}:prod
exit /b

:process_backup
cd backups
docker build -f Dockerfile --tag {{cookiecutter.project_slug}}-backup .
docker tag {{cookiecutter.project_slug}}-backup {{cookiecutter.docker_registry}}/{{cookiecutter.project_slug}}-backup
docker push {{cookiecutter.docker_registry}}/{{cookiecutter.project_slug}}-backup
cd ..
exit /b
