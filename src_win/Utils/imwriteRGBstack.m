function imwriteRGBstack(stack, filename)

im = Tiff(filename, 'w');
infostruct.ImageLength = size(stack, 1);
infostruct.ImageWidth = size(stack, 2);
infostruct.Photometric = Tiff.Photometric.MinIsBlack;
infostruct.BitsPerSample = 8;
infostruct.SampleFormat = Tiff.SampleFormat.UInt;
infostruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
infostruct.SamplesPerPixel=3;
for k = 1:size(stack, 4)
    im.setTag(infostruct)
    im.write(uint8(stack(:, :, :,k)));
    im.writeDirectory();
end
im.close();
end