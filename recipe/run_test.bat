@echo on

python -m pip check
if errorlevel 1 exit 1

jupyter kernelspec list
if errorlevel 1 exit 1

jupyter run -h
if errorlevel 1 exit 1

IF "%PY_VER%"=="3.14" (
	    echo "WARNING: Skipping tests for Python 3.14. Remove it when ipykernel & pytest-jupyter-client are available for Python 3.14."
) ELSE (
    pytest tests -vv --pyargs jupyter_client -k "not (test_start_parallel_process_kernels or test_async_signal_kernel_subprocesses[signaltest-_install_kernel-_ShutdownStatus.ShutdownRequest] or test_start_parallel_thread_kernels or test_input_request or test_load_ips or test_tcp_cinfo)"
)


if errorlevel 1 exit 1
