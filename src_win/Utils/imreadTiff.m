function stack=imreadTiff(filename,threeD)
if nargin < 2 || isempty(threeD)
    threeD=0;
end
info = imfinfo(filename);
frames = numel(info);
stack=zeros(info(1).Height,info(1).Width,frames);
if threeD
    for k = 1:frames
        stack(:,:,k) =single(imread(filename, k));
    end
%     stack=stack./max(stack(:));
else
    for k = 1:frames
        stack(:,:,k) =single(imread(filename, k));
%         stack(:,:,k)=stack(:,:,k)./max(max(stack(:,:,k)));
    end
end