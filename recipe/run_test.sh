set -ex

if [ "$(uname)" == "Darwin" ]; then
    ulimit -n 4096
fi

python -m pip check

jupyter kernelspec list

jupyter run -h

pytest --pyargs jupyter_client --cov jupyter_client --cov-report term-missing:skip-covered
