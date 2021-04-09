function write_tif(data,filename,tifname,threeD,Oversample,constant)
data=double(data);
if threeD==1 ||Oversample==1
    for i=1:size(data,3)
        data(:,:,i)=medfilt2(data(:,:,i),[2,2]);
    end
end
data=data./max(data(:));
% progressbar('Save data')
% for i=1:size(data,3)
if threeD
    imwritestack(constant*data, [filename,'\',tifname,'_reconstructed.tif'])
else
% for k=1:size(data,3)
%	data(:,:,k)=data(:,:,k)./max(max(data(:,:,k)));
% end
    imwritestack(constant*data,[filename,'\',tifname,'_reconstructed.tif']);
end
% progressbar(i/size(data,3))
% end

