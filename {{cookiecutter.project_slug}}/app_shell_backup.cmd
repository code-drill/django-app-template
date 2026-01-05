call app_build_backup.cmd
docker compose -f compose-prod.yml run --build --remove-orphans {{cookiecutter.project_slug}}-backup /bin/bash
