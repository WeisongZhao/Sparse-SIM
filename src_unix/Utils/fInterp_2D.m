function img_ip = fInterp_2D(img, newsz)
% Fourier interpolation of 2D image 'img' to new size 'newsz' = [nx,ny]
% This is similar to performing MATLABs interpft along all dimensions
% individually, but faster.
% Fourier interpolation
% Author: Simon Christoph Stein
% E-Mail: scstein@phys.uni-goettingen.de
% Date: 2017
imgsz = size(img);
%  If necessary, increase ny by an integer multiple to make ny > m.
if sum(newsz == 0) >= 1
    img_ip = [];
    return
end
isgreater = newsz >= imgsz;
incr = zeros(2,1);
for iDim = 1:2
    if isgreater(iDim)
        incr(iDim) = 1;
    else
        incr = floor(imgsz(iDim)/newsz(iDim)) + 1;
        newsz(iDim) = incr(iDim)*newsz(iDim);
    end
end
img_ip = zeros(newsz);
nyqst = ceil((imgsz+1)/2);
img = newsz(1)/imgsz(1)*newsz(2)/imgsz(2)* fft2(img);%  multiplicative factor conserves the counts at the original positions
% zero padding, need to copy all 4 edges of the image plane
% note: xl:'x low', xh:'x high'
img_ip(1:nyqst(1),1:nyqst(2)) = img(1:nyqst(1),1:nyqst(2)); % xl, yl
img_ip(end-(imgsz(1)-nyqst(1))+1:end, 1:nyqst(2)) = img(nyqst(1)+1:imgsz(1),1:nyqst(2)); % xh, yl
img_ip(1:nyqst(1),end-(imgsz(2)-nyqst(2))+1:end) = img(1:nyqst(1), nyqst(2)+1:imgsz(2)); % xl, yh
img_ip(end-(imgsz(1)-nyqst(1))+1:end, end-(imgsz(2)-nyqst(2))+1:end) = img(nyqst(1)+1:imgsz(1), nyqst(2)+1:imgsz(2)); % xh, yh, zl
rm = rem(imgsz,2);
if rm(1) == 0  && newsz(1) ~= imgsz(1)
    img_ip(nyqst(1), :) = img_ip(nyqst(1), :)/2;
    img_ip(nyqst(1) + newsz(1)-imgsz(1), :) = img_ip(nyqst(1), :);
end
if rm(2) == 0  && newsz(2) ~= imgsz(2)
    img_ip(:, nyqst(2)) = img_ip(:, nyqst(2))/2;
    img_ip(:, nyqst(2) + newsz(2)-imgsz(2)) = img_ip(:, nyqst(2));
end
img_ip = real(ifft2(img_ip));
% Skip points if neccessary
img_ip = img_ip(1:incr(1):newsz(1), 1:incr(2):newsz(2));
end
