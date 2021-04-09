function  xxfft=operation_xx(sizeg)

xxfft=fftn([1 -2 1],sizeg).*conj(fftn([1 -2 1],sizeg));