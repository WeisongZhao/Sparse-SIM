function [Lyy,byy]=iter_yy(g,byy,para,gpu,mu)

if nargin < 3 || isempty(para)
    para=1;
end
if nargin < 4 || isempty(gpu)
    %Check for CUDA-1.3-capable or newer graphics card.
    gpu=cudaAvailable;
end
if nargin < 5 || isempty(mu)
    mu=1;
end
gyy = back_diff(forward_diff(g,1,2,gpu),1,2,gpu);
signdyy = abs(gyy+byy)-1/mu;
signdyy(signdyy<0)=0;
signdyy=signdyy.*sign(gyy+byy);
dyy=signdyy;
byy = byy+(gyy-dyy);
Lyy=para*back_diff(forward_diff(dyy-byy,1,2,gpu),1,2,gpu);