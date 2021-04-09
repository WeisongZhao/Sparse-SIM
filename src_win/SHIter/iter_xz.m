function [Lxz,bxz]=iter_xz(g,bxz,para,gpu,mu)

if nargin < 4 || isempty(gpu)
    %Check for CUDA-1.3-capable or newer graphics card.
    gpu=cudaAvailable;
end
if nargin < 5 || isempty(mu)
    mu=1;
end
gxz = forward_diff(forward_diff(g,1,1,gpu),1,3,gpu);
signdxz = abs( gxz+bxz)-1/mu;
signdxz(signdxz<0)=0;
signdxz=signdxz.*sign( gxz+bxz);
dxz=signdxz;
bxz = bxz+(gxz-dxz);
Lxz=para*back_diff(back_diff(dxz-bxz,1,3,gpu),1,1,gpu);