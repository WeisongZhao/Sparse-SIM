function imwritestack(stack, filename,constant)
t = Tiff(filename, 'w');

tagstruct.ImageLength = size(stack, 1);
tagstruct.ImageWidth = size(stack, 2);
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = 32;
tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;

for k = 1:size(stack, 3)
    t.setTag(tagstruct)
    t.write(single(stack(:, :, k)));
    t.writeDirectory();
end

t.close();
end