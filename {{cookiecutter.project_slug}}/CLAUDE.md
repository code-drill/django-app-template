# Project Information

This is a python django project

## Key Details
- framework: django
- project file: pyproject.toml
- django settings file ./app/src/core/settings.py
- 

## Management Commands

### run django commands
** for CLAUDE code / desktop on windows use **  
use `./app_shell_run.bsh "uv run --active /app/app/src/manage.py <PUT_HERE_COMMAND>"` where `<PUT_HERE_COMMAND>` should be replaced with django command

### run any script
** for CLAUDE code / desktop on windows use **  
in order to run python script in django context create some file: `script.py`  
and then run: `./app_shell_run.bsh "uv run --active script.py"` to execute script in django context
