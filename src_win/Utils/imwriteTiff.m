function imwriteTiff(tifimage, filename)
i = Tiff(filename, 'w');
infostruct.ImageLength = size(tifimage, 1);
infostruct.ImageWidth = size(tifimage, 2);
infostruct.Photometric = Tiff.Photometric.MinIsBlack;
infostruct.BitsPerSample = 16;
infostruct.SampleFormat = Tiff.SampleFormat.UInt;
infostruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
i.setTag(infostruct)
i.write(uint16(tifimage));
i.writeDirectory();
i.close();
end