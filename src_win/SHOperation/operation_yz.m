function  yzfft=operation_yz(sizeg)
gradientyz(:,:,1)=[1;-1];
gradientyz(:,:,2)=[-1;1];
yzfft= fftn(gradientyz,sizeg).*conj(fftn(gradientyz,sizeg));