function c = robustnorm2(f, f_hat, sigma_noise)
% ROBUSTNORM2 - function used in normalized convolution
% ROBUSTNORM2 - ���ڹ淶������ĺ���
% sigma_noise is the standard deviation of the input noise
% ���������������ı�׼��

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%
c = exp(-((f-f_hat).^2) ./ 2*sigma_noise^2);