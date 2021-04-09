function data_de=Iterative_deblur(data,kernel,iteration,rule,gpu)

if nargin < 3 || isempty(iteration)
    iteration=10;
end
if nargin < 4 || isempty(rule)
    rule=1;
end
if nargin < 5 || isempty(gpu)
    gpu=cudaAvailable;
end
progressbar('Iterative deblur');
data=data./max(data(:));
if ndims(data)==3
    for i=1:size(data,3)
        data_de(:,:,i)=real(deblur_core(data(:,:,i),kernel,iteration,rule,gpu));
        progressbar(i/size(data,3));
    end
    %     data_de=data_de./max(data_de(:));
else
    data_de=real(deblur_core(data,kernel,iteration,rule,gpu));
    %     data_de=data_de./max(data_de(:));
    progressbar(1);
end