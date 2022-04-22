@echo on

python -m pip check
if errorlevel 1 exit 1

jupyter kernelspec list
if errorlevel 1 exit 1

jupyter run -h
if errorlevel 1 exit 1

pytest -vv --pyargs jupyter_client
if errorlevel 1 exit 1
