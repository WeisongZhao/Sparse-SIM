function psf=kernel(pixel, lambda, NA,z,n)

if nargin < 4 || isempty(z)
    z=0;
end
if nargin < 5 || isempty(n)
    n=17;
end
if n<33 && n>17
    nn=8;
elseif n<65 && n>33
    nn=16;
elseif n<129 && n>65
    nn=32;
elseif n<257&& n>129
    nn=64;
else
    nn=64;
end
psf=Generate_PSF(pixel,lambda,nn,NA,z);
psf=psf./sum(sum(psf));
