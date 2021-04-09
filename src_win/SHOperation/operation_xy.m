function  xyfft=operation_xy(sizeg)
xyfft=fftn([1 -1;-1 1],sizeg).*conj(fftn([1 -1;-1 1],sizeg));
