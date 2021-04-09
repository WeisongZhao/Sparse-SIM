function  xzfft=operation_xz(sizeg)
gradientxz(:,:,1)=[1,-1];
gradientxz(:,:,2)=[-1,1];
xzfft=fftn(gradientxz,sizeg).*conj(fftn(gradientxz,sizeg));
