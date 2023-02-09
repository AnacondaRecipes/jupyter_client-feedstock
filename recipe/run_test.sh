#!/bin/bash

set -ex

$PYTHON -m pip check

jupyter kernelspec list

jupyter run -h

if [ "$(uname)" == "Darwin" ]; then
    ulimit -n 4096
    pytest --asyncio-mode=auto --pyargs jupyter_client --cov jupyter_client --cov-report term-missing:skip-covered --no-cov-on-fail -k "not (test_install_kernel_spec_prefix)" 
# Timeout issues on most platforms
else
    pytest --asyncio-mode=auto --pyargs jupyter_client --cov jupyter_client --cov-report term-missing:skip-covered --no-cov-on-fail -vv \
    -k "not (test_start_parallel_process_kernels[tcp] \
    or test_async_signal_kernel_subprocesses[signaltest-_install_kernel-_ShutdownStatus.ShutdownRequest] \
    or test_start_sequence_kernels[tcp] or test_start_sequence_kernels[ipc] \
    or test_start_parallel_thread_kernels[tcp] \
    or test_start_sequence_process_kernels[tcp] or test_signal_kernel_subprocesses \
    or test_start_new_async_kernel or test_shutdown or test_restart_check[tcp])"
fi
