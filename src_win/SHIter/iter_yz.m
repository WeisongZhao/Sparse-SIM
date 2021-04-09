function [Lyz,byz]=iter_yz(g,byz,para,gpu,mu)

if nargin < 4 || isempty(gpu)
    %Check for CUDA-1.3-capable or newer graphics card.
    gpu=cudaAvailable;
end
if nargin < 5 || isempty(mu)
    mu=1;
end
gyz = forward_diff(forward_diff(g,1,2,gpu),1,3,gpu);
signdyz = abs(gyz+byz)-1/mu;
signdyz(signdyz<0)=0;
signdyz=signdyz.*sign(gyz+byz);
dyz=signdyz;
byz = byz+(gyz-dyz);
Lyz= para*back_diff(back_diff(dyz-byz,1,3,gpu),1,2,gpu);