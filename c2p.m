function impolar = c2p(im)
% IMPOLAR - compute the polar coordinates of the pixels of an image
% IMPOLAR(C2P)-����ͼ������ص�ļ�����
%    impolar = c2p(im)
%    convert an image in cartesian coordinates IM
%    to an image in polar coordinates IMPOLAR
%    ���ѿ�������ϵ�е�ͼ��ת����������ϵ

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%

[nrows, ncols] = size(im);

% create the regular rho,theta grid
% ��������ѣ�������

r = ones(nrows,1)*[0:nrows-1]/2;
th = [0:nrows-1]'*ones(nrows,1)'*2*pi/nrows-pi;  %'��ת��

% convert the polar coordinates to cartesian 
% ��������ת��Ϊ�ѿ������� 
[xx,yy] = pol2cart(th,r); %pol2cart�������ڽ�������ת��Ϊ�ѿ�������
xx = xx + nrows/2+0.5;
yy = yy + nrows/2+0.5;

% interpolate using bilinear interpolation to produce the final image
% ʹ��˫���Բ�ֵ�������յ�ͼ��
partx = xx-floor(xx); partx = partx(:);
party = yy-floor(yy); party = party(:);
% floor��������ȡ��  (:)�ǽ�����ת��Ϊ���� ��˳���ų�һ��

impolar = (1-partx).*(1-party).*reshape(im(floor(yy)+nrows*(floor(xx)-1)),[nrows*ncols 1])...
    + partx.*(1-party).*reshape(im(floor(yy)+nrows*(ceil(xx)-1)),[nrows*ncols 1])...
    + (1-partx).*party.*reshape(im(ceil(yy)+nrows*(floor(xx)-1)),[nrows*ncols 1])...
    + partx.*party.*reshape(im(ceil(yy)+nrows*(ceil(xx)-1)),[nrows*ncols 1]);
%reshape�������ڷ�����A������ͬԪ�ص�Nά���飨���ص������Ԫ�غ�A��Ԫ����ȣ�

impolar = reshape(impolar,[nrows ncols]);
