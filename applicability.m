function [Z X Y] = applicability(a, b, rmax)
% APPLICABILITY�����ڲ���һ�����ڹ淶������������Ժ���

% Z is the applicability matrix and X, Y are the grid coordinates if a 3D
% plot is required.
% Z��Ӧ�þ�����3Dͼ��X,Y����������

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%

[X Y] = meshgrid(-rmax:rmax, -rmax:rmax);  %meshgrid:��������㺯�� ��������3Dͼ

Z = sqrt(X.^2+Y.^2).^(-a).*cos((pi*sqrt(X.^2+Y.^2))/(2*rmax)).^b;
Z = Z .* double(sqrt(X.^2+Y.^2) < rmax); % We want Z=0 outside of rmax   ������Ҫ��rmax��Χ��Z=0
Z(rmax+1, rmax+1) = 1;