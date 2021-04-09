function gpu=cudaAvailable
try
    gpu=parallel.gpu.GPUDevice.current();
    gpu=gpu.DeviceSupported;
catch msg
    gpu=false;
end