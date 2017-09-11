function [delta_est, phi_est] = estimate_motion(s,r_max,d_max)
% ESTIMATE_MOTION - shift and rotation estimation using algorithm by Vandewalle et al.
%                 -��Vandewalle�㷨��λ�ƺ���ת���й���

%    [delta_est, phi_est] = estimate_motion(s,r_max,d_max)
%    R_MAX is the maximum radius in the rotation estimation
%    R_MAX����ת���Ƶ����뾶  

%    D_MAX is the number of low frequency components used for shift estimation
%    D_MAX������λ�ƹ��Ƶĵ�Ƶ�ɷֵ�����

%    input images S are specified as S{1}, S{2}, etc.
%    �����ͼƬA���α�ָ��ΪS{1},S{2}��
%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%

if (nargin==1) % default values  ��Чֵ
   r_max = 0.8;
   d_max = 8;
end

% rotation estimation
% ��ת����
[phi_est, c_est] = estimate_rotation(s,[0.1 r_max],0.1);

% rotation compensation, required to estimate shifts
% ��ת���õĽ����Ҳ����λ�ƹ���
s2{1} = s{1};
nr=length(s);
for i=2:nr
    s2{i} = imrotate(s{i},-phi_est(i),'bicubic','crop');
end

% shift estimation
% λ�ƹ���
delta_est = estimate_shift(s2,d_max);


