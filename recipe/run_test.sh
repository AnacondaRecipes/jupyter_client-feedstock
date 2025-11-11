#!/bin/bash

set -ex

$PYTHON -m pip check

jupyter kernelspec list

jupyter run -h

if [ "$(uname)" == "Darwin" ]; then
    ulimit -n 4096
fi

PYTHON_MINOR_VERSION=$(python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
echo "PYTHON_MINOR_VERSION: $PYTHON_MINOR_VERSION"

# Workaround for the python 3.14 build-out because ipykernel & pytest-jupyter-client are a circular dependency
if [ "$PYTHON_MINOR_VERSION" == "3.14" ]; then
    echo "WARNING: Skipping tests for Python 3.14. Remove it when ipykernel & pytest-jupyter-client is available for Python 3.14."
else
    # Timeout issues on most platforms
    pytest tests --pyargs jupyter_client --cov jupyter_client --cov-report term-missing:skip-covered --no-cov-on-fail -vv \
    -k "not (test_start_parallel_process_kernels \
    or test_async_signal_kernel_subprocesses[signaltest-_install_kernel-_ShutdownStatus.ShutdownRequest] \
    or test_start_parallel_thread_kernels \
    or test_input_request \
    or test_load_ips \
    or test_tcp_cinfo)"
fi
