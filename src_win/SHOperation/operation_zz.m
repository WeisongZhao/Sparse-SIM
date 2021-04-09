function  zzfft=operation_zz(sizeg)
gradientzz(:,:,1)=1;
gradientzz(:,:,2)=-2;
gradientzz(:,:,3)=1;
zzfft=fftn(gradientzz,sizeg).*conj(fftn(gradientzz,sizeg));
