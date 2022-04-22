set -ex

python -m pip check

jupyter kernelspec list

jupyter run -h

if [ "$(uname)" == "Darwin" ]; then
    ulimit -n 4096
    pytest --pyargs jupyter_client --cov jupyter_client --cov-report term-missing:skip-covered --no-cov-on-fail -k "not (test_install_kernel_spec_prefix)" 
# Timeout issues with python 3.10 on ppc64le
elif [ "$(uname -m)" = "ppc64le" ]; then
    pytest --pyargs jupyter_client --cov jupyter_client --cov-report term-missing:skip-covered --no-cov-on-fail \
    -k "not (test_start_parallel_process_kernels[tcp] \
    or test_async_signal_kernel_subprocesses[signaltest-_install_kernel-_ShutdownStatus.ShutdownRequest] \
    or test_start_sequence_kernels[tcp] or test_start_sequence_kernels[ipc] \
    or test_start_parallel_thread_kernels[tcp] \
    or test_start_sequence_process_kernels[tcp] or test_signal_kernel_subprocesses \
    or test_start_new_async_kernel)"
# Timeout issues or RuntimeError: Kernel died before replying to kernel_info (on s390x)
elif [ "$(uname -m)" = "s390x" ]; then
    pytest --pyargs jupyter_client --cov jupyter_client --cov-report term-missing:skip-covered --no-cov-on-fail \
    -k "not (test_start_parallel_process_kernels[tcp] \
    or test_async_signal_kernel_subprocesses[signaltest-_install_kernel-_ShutdownStatus.ShutdownRequest] \
    or test_start_sequence_kernels[tcp] or test_start_sequence_kernels[ipc] \
    or test_start_parallel_thread_kernels[tcp] \
    or test_start_sequence_process_kernels[tcp] or test_signal_kernel_subprocesses \
    or test_start_new_async_kernel or test_shutdown or test_restart_check[tcp])"
else
    pytest --pyargs jupyter_client --cov jupyter_client --cov-report term-missing:skip-covered --no-cov-on-fail 
fi
