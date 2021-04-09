function stack=imreadRGBTiff(filename)
info = imfinfo(filename);
frames = numel(info);
stack=zeros(info(1).Height,info(1).Width,3,frames);
for k = 1:frames
    stack(:,:,:,k) =single(imread(filename, k));
end
