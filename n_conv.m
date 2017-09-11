function [rec, F] = n_conv(s,delta_est,phi_est,factor, noiseCorrect, TwoPass)
% N_CONV - reconstruct a high resolution image using normalized convolution
%          �ñ�׼������ؽ��߷ֱ���ͼ��
%    [rec, F] = n_conv(s,delta_est,phi_est,factor, noiseCorrect, TwoPass)
%    reconstruct an image with FACTOR times more pixels in both dimensions
%    using normalized convolution on the pixels from the images in S
%    (S{1},...) and using the shift and rotation information from DELTA_EST 
%    and PHI_EST; options are available to specify whether a noise correction
%    step and a second pass should be applied or not
%    ����ͼ��S���صı�׼�������DELTA_EST��PHI_EST����ת��λ����Ϣ�ؽ����������򣨺�������ᣩ���и������ص��FACTOR����

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%

if nargin < 4
    errordlg('Not enough input arguments', 'Error...');
elseif nargin < 5
    noiseCorrect = false;
    TwoPass = false;
end

n=length(s);
ss = size(s{1});
if (length(ss)==3) 
    error('This function only takes 2-dimensional matrices'); 
end
center = (ss+1)/2;
phi_rad = phi_est*pi/180;

% compute the coordinates of the pixels from the N images, using DELTA_EST and PHI_EST
% ����DELTA_EST��PHI_EST����Nͼ�����ص�����
for i=1:n % for each image ��ÿ��ͼ��
    s_c{i}=s{i};
    s_c{i} = s_c{i}(:);
    r{i} = [1:factor:factor*ss(1)]'*ones(1,ss(2)); % create matrix with row indices �����������������ָ����
    c{i} = ones(ss(1),1)*[1:factor:factor*ss(2)]; % create matrix with column indices  ��
    r{i} = r{i}-factor*center(1); % shift rows to center around 0   �����Ƶ�0����������
    c{i} = c{i}-factor*center(2); % shift columns to center around 0
    coord{i} = [c{i}(:) r{i}(:)]*[cos(phi_rad(i)) sin(phi_rad(i)); -sin(phi_rad(i)) cos(phi_rad(i))]; % rotate 
    r{i} = coord{i}(:,2)+factor*center(1)+factor*delta_est(i,1); % shift rows back and shift by delta_est
                                                                 % ��delta_est���������                                                              
    c{i} = coord{i}(:,1)+factor*center(2)+factor*delta_est(i,2); % shift columns back and shift by delta_est
    rn{i} = r{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
    cn{i} = c{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
    sn{i} = s_c{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
end

s_ = []; r_ = []; c_ = []; sr_ = []; rr_ = []; cr_ = [];
for i=1:n % for each image 
    s_ = [s_; sn{i}];
    r_ = [r_; rn{i}];
    c_ = [c_; cn{i}];
end
clear s_c r c coord rn cn sn

% Apply the normalized convolution algorithm  Ӧ�ñ�׼������㷨
if nargout == 2
    [rec, F] = n_convolution(c_,r_,s_,ss*factor,factor, s{1}, noiseCorrect, TwoPass);
else
    rec = n_convolution(c_,r_,s_,ss*factor,factor, s{1}, noiseCorrect, TwoPass);
end

rec(isnan(rec))=0;   %insan�����ж������е������Ƿ�Ϊ�����
