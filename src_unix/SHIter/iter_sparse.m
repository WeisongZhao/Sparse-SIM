function [Lsparse,bsparse]=iter_sparse(g,bsparse,para,gpu,mu)

if nargin < 4 || isempty(gpu)
    gpu=cudaAvailable;
end
if nargin < 5 || isempty(mu)
    mu=1;
end
gsparse=g;
signd=abs(gsparse+bsparse)-1/mu;
signd(signd<0)=0;
signd=signd.*sign(gsparse+bsparse);
d=signd;
bsparse = bsparse+(gsparse-d);
Lsparse=para*(d-bsparse);