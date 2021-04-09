function imgfl = Fourier_Oversample( imgstack, n)
%***************************************************************************
% Fourier interpolation 
%***************************************************************************
% function imgfl = Fourier_Oversample( imgstack, n)
%-----------------------------------------------
%Source code for background estimation
%imgstack    input data
%n           magnification times  {default:2}
%------------------------------------------------
%Output:
%  imgfl
%***************************************************************************
% Written by WeisongZhao @ zhaoweisong950713@163.com
% Version 1.0.3
% if any bugs is found, please just email me or put an issue on the github.
%***************************************************************************
% https://weisongzhao.github.io/Sparse-SIM/
%***************************************************************************
% It is a part of publication:
% Weisong Zhao et al. Extending resolution of structured illumination
% microscopy with sparse deconvolution, Nature Biotechnology, X, XXX-XXX (2021).
% *********************************************************************************
%   Copyright 2019~2021 Weisong Zhao et al.
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%***************************************************************************
if nargin < 2 || isempty(n)
    n=2;
end
n = repmat(n,[1,2]);
for i=1:size(imgstack,3)
    img=imgstack(:,:,i);
    imgsz = size(img);
    sz = imgsz - ~mod(imgsz,2);
    idx = ceil(sz/2)+1 + (n-1).*floor(sz/2);
    padsize = [size(img,1)/2,size(img,2)/2];
    img = padarray(img,ceil(padsize),'symmetric','pre');
    img = padarray(img,floor(padsize),'symmetric','post');
    newsz = round(n.*size(img)-(n-1));
    imgl = fInterp_2D(img, newsz);
    imgfl(:,:,i) = imgl(idx(1):idx(1)+n(1)*imgsz(1)-1, idx(2):idx(2)+n(2)*imgsz(2)-1);
end
