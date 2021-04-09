function  yyfft=operation_yy(sizeg)

yyfft=fftn([1 ;-2 ;1],sizeg).*conj(fftn([1; -2 ;1],sizeg));
