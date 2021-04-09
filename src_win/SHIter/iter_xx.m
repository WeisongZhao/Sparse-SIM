function [Lxx,bxx]=iter_xx(g,bxx,para,gpu,mu)

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

gxx = back_diff(forward_diff(g,1,1,gpu),1,1,gpu);
signdxx = abs(gxx+bxx)-1/mu;
signdxx(signdxx<0)=0;
signdxx=signdxx.*sign(gxx+bxx);
dxx=signdxx;
bxx = bxx+(gxx-dxx);
Lxx = para*back_diff(forward_diff(dxx-bxx,1,1,gpu),1,1,gpu);