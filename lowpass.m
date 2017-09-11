function s_low = lowpass(s,part)
% LOWPASS - low-pass filter an image by setting coefficients to zero in frequency domain
%         - ͨ������Ƶ����ϵ��Ϊ���ͼ����е�ͨ�˲�
%    s_low = lowpass(s,part)
%    S is the input image SΪ����ͼ��
%    PART indicates the relative part of the frequency range [0 pi] to be kept
%    PART�����ʾ�����Ƶ�ʱ仯��Ϊ0~pi����ز���

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%

% set coefficients to zero ����ϵ��Ϊ��
if size(s,1)>1 % 2D signal ����ά�ȵ��ź�
    S = fft2(s); % compute the Fourier transform of the image ����ͼ��ĸ���Ҷ�任
    S(round(part(1)*size(S,1))+1:round((1-part(1))*size(S,1))+1,:) = 0;
    S(:,round(part(2)*size(S,2))+1:round((1-part(2))*size(S,2))+1) = 0;
    s_low = real(ifft2(S)); % compute the inverse Fourier transform of the filtered image   
                            % �����˲���ͼ��ĸ���Ҷ���任
else % 1D signal һ��ά�ȵ��ź�
    S = fft(s); % compute the Fourier transform of the image  ����ͼ��ĸ���Ҷ�任
    S(round(part*length(S))+1:round((1-part)*length(S))+1) = 0;
    s_low = real(ifft(S)); % compute the inverse Fourier transform of the filtered signal  �����˲����źŵĸ���Ҷ���任
end
