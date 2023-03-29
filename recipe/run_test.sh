#!/bin/bash

set -ex

$PYTHON -m pip check

jupyter kernelspec list

jupyter run -h

if [ "$(uname)" == "Darwin" ]; then
    ulimit -n 4096
    pytest tests --pyargs jupyter_client --cov jupyter_client --cov-report term-missing:skip-covered --no-cov-on-fail -vv \ 
    -k "not test_tcp_cinfo"
# Timeout issues on most platforms
else
    pytest tests --pyargs jupyter_client --cov jupyter_client --cov-report term-missing:skip-covered --no-cov-on-fail -vv \
    -k "not (test_start_parallel_process_kernels \
    or test_async_signal_kernel_subprocesses[signaltest-_install_kernel-_ShutdownStatus.ShutdownRequest] \
    or test_start_parallel_thread_kernels \
    or test_input_request \
    or test_load_ips \
    or test_tcp_cinfo)"
fi
