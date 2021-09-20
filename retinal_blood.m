function Output_Image = retinal_blood(Input_Image, mask)

	red_channel = Input_Image(:, :, 1);
	green_channel = Input_Image(:, :, 2);
	blue_channel = Input_Image(:, :, 3);

	gray_scale = rgb2gray(Input_Image);
    
    %%%%%%%%%%%%%%%%%%%% Contrast enhancement
	gray_scale = adapthisteq(gray_scale);
	green_channel = adapthisteq(green_channel);
    %%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%% Excluding background
	gray_scale_filtered = imfilter(gray_scale, fspecial('average', [9 9]));
	green_channel_filtered = imfilter(green_channel, fspecial('average', [9 9]));

	gray_scale_filtered(mask==0)=0;
	green_channel_filtered(mask==0)=0;

	gray_scale_h = zeros(size(Input_Image, 1), size(Input_Image, 2), class(Input_Image));
	green_channel_h = zeros(size(Input_Image, 1), size(Input_Image, 2), class(Input_Image));

	for i=1:size(Input_Image, 1)
		for j=1:size(Input_Image, 2)
			temp = gray_scale_filtered(i, j) - gray_scale(i, j);
			if temp > 0
				gray_scale_h(i, j) = temp;
			end
		end
	end

	for i=1:size(Input_Image, 1)
		for j=1:size(Input_Image, 2)
			temp = green_channel_filtered(i, j) - green_channel(i, j);
			if temp > 0
				green_channel_h(i, j) = temp;
			end
		end
    end
    %%%%%%%%%%%%%%%%%%%% End of excluding background
    
    %%%%%%%%%%%%%%%%%%%% Thrsholding
	gray_scale_threshold = isodata(gray_scale_h);
	green_channel_threshold = isodata(green_channel_h);
    %%%%%%%%%%%%%%%%%%%%
    
	gray_BW = im2bw(gray_scale_h, gray_scale_threshold);
	green_BW = im2bw(green_channel_h, green_channel_threshold);

    %%%%%%%%%%%%%%%%%%%% Removing objects with less than 35 white pixels
    gray_BW = bwareaopen(gray_BW, 35);
	green_BW = bwareaopen(green_BW, 35);
    %%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%% Combinig gray-scale and green channel
	Output_Image = ones(size(Input_Image, 1), size(Input_Image, 2), class(Input_Image));
	for i=1:size(Input_Image, 1)
		for j=1:size(Input_Image, 2)
			if gray_BW(i, j) == 0 && green_BW(i, j) == 0
				Output_Image(i, j) = 0;
			end
		end
    end
    %%%%%%%%%%%%%%%%%%%%
    
	Output_Image = bwareaopen(Output_Image, 35);

end