function Background = background_estimation(imgs,th,dlevel,wavename,iter)
**************************************************************************************
% Background estimation
**************************************************************************************
% function Background = background_estimation(imgs,th,dlevel,wavename,iter)
%-----------------------------------------------
%Source code for background estimation
%imgs        input data
%th          if iteration {default:1}
%dlevel      decomposition level {default:7}
%wavename    The selected wavelet function {default:'db6'}
%iter        iteration {default:3}
%------------------------------------------------
%Output:
%  Background
**************************************************************************************
% Written by WeisongZhao @ zhaoweisong950713@163.com
% Version 1.0.3
% if any bugs is found, please just email me or put an issue on the github.
**************************************************************************************
% https://weisongzhao.github.io/Sparse-SIM/
% **************************************************************************************
% It is a part of publication:
% Weisong Zhao et al. Sparse deconvolution improves the resolution of live-cell
% super-resolution fluorescence microscopy , Nature Biotechnology, 40, 606–617 (2022).
% https://doi.org/10.1038/s41587-021-01092-2
% **************************************************************************************
%    Copyright 2018~2021 Weisong Zhao et al.
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the Open Data Commons Open Database License v1.0.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%    Open Data Commons Open Database License for more details.
%
%    You should have received a copy of the 
%    Open Data Commons Open Database License
%    along with this program.  If not, see:
%    <https://opendatacommons.org/licenses/odbl/>.
**************************************************************************************
if nargin < 2 || isempty(th)
    th=1;
end
if nargin < 3 || isempty(dlevel)
    dlevel=7;
end
if nargin < 4 || isempty(wavename)
    wavename='db6';
end
if nargin < 5 || isempty(iter)
    iter=3;
end
[x,y,~]=size(imgs);
if x<y
    imgs=padarray(imgs,[max(x,y)-size(imgs,1)...
        ,max(x,y)-size(imgs,2),0],'post','symmetric');
end
Background = zeros(size(imgs),'single');
progressbar('Background estimation');
for frames = 1: size(imgs,3)
    initial = imgs(:,:,frames);
    res = initial;
    for ii = 1:iter
        [m,n] = wavedec2(res,dlevel,wavename);
        vec = zeros(size(m));
        vec(1:n(1)*n(1)*1) = m(1:n(1)*n(1)*1);
        Biter =  waverec2(vec,n,wavename);
        if th > 0
            eps = sqrt(abs(res))/2;
            ind = initial>(Biter+eps);
            res(ind) = Biter(ind)+eps(ind);
            [m,n] = wavedec2(res,dlevel,wavename);
            vec = zeros(size(m));
            vec(1:n(1)*n(1)*1) = m(1:n(1)*n(1)*1);
            Biter =  waverec2(vec,n,wavename);
        end
    end
    Background(:,:,frames) = Biter;
    progressbar(frames/size(imgs,3));
end
Background=Background(1:x,1:y,:);