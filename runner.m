clc
clear

imagesDatasetPath = 'C:\Users\Mahdi\Desktop\HW4 - Mahdi Naderi\DRIVE\Test\images\';
gtImagesPath = 'C:\Users\Mahdi\Desktop\HW4 - Mahdi Naderi\DRIVE\Test\1st_manual\';
maskPath = 'C:\Users\Mahdi\Desktop\HW4 - Mahdi Naderi\DRIVE\Test\mask\';
outputPath = 'C:\Users\Mahdi\Desktop\HW4 - Mahdi Naderi\Q5\Results\';
images = dir(imagesDatasetPath);
ground_truth = dir(gtImagesPath);
masks = dir(maskPath);

image_num = cell(20, 1);
sensitivity = cell(20, 1);
specificity = cell(20, 1);
accuracy = cell(20, 1);

for i=1:numel(images)
	if images(i).isdir == 0
		img = imread([imagesDatasetPath images(i).name]);
		mask = imread([maskPath masks(i).name]);
        gt = imread([gtImagesPath ground_truth(i).name]);
		output = retinal_blood(img, mask);
		output(mask==0)=0;
 		imshow(output, []);
		pause(0.25);
		imwrite(output, [outputPath images(i).name]);
        
        TP=0;
        FP=0;
        TN=0;
        FN=0;
        output = uint8(output);
        output(output==1) = 255;
        for m=1:size(output, 1)
            for n=1:size(output, 2)
                if gt(m, n)==255 && output(m, n)==255
                    TP=TP+1;
                elseif gt(m, n)==0 && output(m, n)==255
                    FP=FP+1;
                elseif gt(m, n)==0 && output(m, n)==0
                    TN=TN+1;
                else
                    FN=FN+1;
                end
            end
        end
        sensitivity_tmp = TP/(TP+FN);
        specificity_tmp = TN/(TN+FP);
        accuracy_tmp = (TP+TN)/(TP+TN+FP+FN);
        
        image_num{i-2} = i-2;
        sensitivity{i-2} = sensitivity_tmp;
        specificity{i-2} = specificity_tmp;
        accuracy{i-2} = accuracy_tmp;
	end
end

final_table = [{'image number', 'sensitivity', 'specifity', 'accuray'}; ...
    image_num, sensitivity, specificity, accuracy];

writecell(final_table, 'C:\Users\Mahdi\Desktop\HW4 - Mahdi Naderi\Q5\Q5_Results.xls');
