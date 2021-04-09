function [Lxy,bxy]=iter_xy(g,bxy,para,gpu,mu)

if nargin < 4 || isempty(gpu)
    %Check for CUDA-1.3-capable or newer graphics card.
    gpu=cudaAvailable;
end
if nargin < 5 || isempty(mu)
    mu=1;
end

gxy = forward_diff(forward_diff(g,1,1,gpu),1,2,gpu);
signdxy = abs(gxy+bxy)-1/mu;
signdxy(signdxy<0)=0;
signdxy=signdxy.*sign(gxy+bxy);
dxy=signdxy;
bxy = bxy+(gxy-dxy);
Lxy=para* back_diff(back_diff(dxy-bxy,1,2,gpu),1,1,gpu);