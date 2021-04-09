function [Lzz,bzz]=iter_zz(g,bzz,para,gpu,mu)
if nargin < 4 || isempty(gpu)
    %Check for CUDA-1.3-capable or newer graphics card.
    gpu=cudaAvailable;
end
if nargin < 5 || isempty(mu)
    mu=1;
end

gzz = back_diff(forward_diff(g,1,3,gpu),1,3,gpu);
signdzz = abs(gzz+bzz)-1/mu;
signdzz(signdzz<0)=0;
signdzz=signdzz.*sign(gzz+bzz);
d=signdzz;
bzz = bzz+(gzz-d);
Lzz=para*back_diff(forward_diff(d-bzz,1,3,gpu),1,3,gpu);