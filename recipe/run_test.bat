@echo on

jupyter kernelspec list
if errorlevel 1 exit 1

jupyter run -h
if errorlevel 1 exit 1

pytest --pyargs jupyter_client --cov jupyter_client --cov-report term-missing:skip-covered
if errorlevel 1 exit 1
