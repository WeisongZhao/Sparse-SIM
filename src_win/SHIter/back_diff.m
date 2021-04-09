function out = back_diff(data,step,dim,gpu)

if nargin < 4 || isempty(gpu)
    %Check for CUDA-1.3-capable or newer graphics card.
    gpu=0;
end
[m, n, r]=size(data);
shift=[m,n,r];
position = ones(1,3);
if gpu==1
    shiftdata1  = gpuArray.zeros(shift+1,'single');
    shiftdata2 = shiftdata1;
else
    shiftdata1 =zeros(shift+1);
    shiftdata2 =zeros(shift+1);
end
shiftdata1(position(1):shift(1),position(2):shift(2),position(3):shift(3))=data;
shiftdata2(position(1):shift(1),position(2):shift(2),position(3):shift(3))=data;
shift(dim)=shift(dim)+1;
position(dim)=position(dim)+1;
shiftdata2(position(1):shift(1),position(2):shift(2),position(3):shift(3))=data;
shiftdata1 = (shiftdata1-shiftdata2)/step;
shift(dim)=shift(dim)-1;
out = shiftdata1(1:shift(1),1:shift(2),1:shift(3));
end

