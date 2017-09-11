function [s, ground_truth] = create_images(im,delta,phi,scale,nr,snr)
% CREATE_IMAGES - generate low resolution shifted and rotated images
%               - �����ͷֱ��ʵĴ���λ�ƺ���ת��ͼ��

%    [s, ground_truth] = create_images(im,delta,phi,scale,nr,snr)
%    create NR low resolution images from a high resolution image IM,
%     NRΪ�ͷֱ���ͼ����� IMΪ�߷ֱ���ͼ�����

%    with shifts DELTA (multiples of 1/8) and rotation angles PHI (degrees)
%     DELTAΪλ�ƾ���1/8�ı����� PHIΪ��ת�ǶȾ��󣨶ȣ�

%    the low resolution images have a factor SCALE less pixels
%    in both dimensions than the input image IM
%    �ͷֱ���ͼ����һ��factor SCALE ����������������ά���϶��������ͼ��Ҫ��

%    if SNR is specified, noise is added to the different images to obtain
%    the given SNR value
%    ���SNRָ�����������ӵ���ͬ��ͼ���Ա��ָ�����SNRֵ

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%

im=resample(im,2,1)'; % upsample the image by 2
im=resample(im,2,1)'; %resampleΪ������������2Hz��Ƶ�ʽ��в���
for i=2:nr
    im2{i} = shift(im,-delta(i,2)*2*scale,-delta(i,1)*2*scale); % shift the images by integer pixels
                                                                %�������������ƶ�ͼ��
    if (phi(i) ~= 0)
      im2{i} = imrotate(im2{i},phi(i),'bicubic','crop'); % rotate the images
                                                         %�����ת�ǶȲ�Ϊ�㣬����תͼ��
    end
end
im2{1} = im; % the first image is not shifted or rotated
             %��һ���ͷֱ���ͼ��û��λ��Ҳû�з�����ת
for i=1:nr
    im2{i} = lowpass(im2{i},[0.12 0.12]); % low-pass filter the images   ��ͼ����е�ͨ�˲�
                                            % such that they satisfy the conditions specified in the paper
                                            %�������Ǿ�������Ҫ�������
                                            % a small aliasing-free part of the frequency domain is needed
                                            %һ��С��Ƶ����ģ����ɣ�������Ǳ����
    if (i==1) % construct ground truth image as reconstruction target
               %ȷ��ĸͼ�񣨻���ͼ��Ϊ�ؽ���Ŀ��
     ground_truth=downsample(im2{i},4)';  %downsampleΪȡ������
     ground_truth=downsample(ground_truth,4)';
    end
    im2{i} = downsample(im2{i},2*scale)'; % downsample the images by 8  ��8Ϊ��λ����ȡ��
    im2{i} = downsample(im2{i},2*scale)';
end

% add noise to the images (if an SNR was specified)
%���SNR������ָ��������ͼ���м�������
if (nargin==6)
  for i=1:nr
    S = size(im2{i});
    n = randn(S(1),S(2));   %randn(m,n)������һ��m*n����������
    n = sqrt(sum(sum(im2{i}.*im2{i}))/sum(sum(n.*n)))*10^(-snr/20)*n;
    s{i} = im2{i}+n; %��������
    %snr = 10*log10(sum(sum(im2{i}.*im2{i}))/sum(sum(n.*n)))
  end
else
  s=im2;
end
