function delta_est = estimate_shift(s,n)
% ESTIMATE_SHIFT - shift estimation using algorithm by Vandewalle et al.
%                - ��Vandewalle�㷨����λ��
%    delta_est = estimate_shift(s,n)
%    estimate shift between every image and the first (reference) image
%    ��ÿһ��ͼ��͵�һ��ͼ�����λ��
%    N specifies the number of low frequency pixels to be used
%    ����Nָ�����õ��ĵ�Ƶ���ص������
%    input images S are specified as S{1}, S{2}, etc.

%    DELTA_EST is an M-by-2 matrix with M the number of images
%    DELTA_EST ��һ��M*2�ľ���M��ͼ�������

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%

h = waitbar(0, 'Shift Estimation');    %������
set(h, 'Name', 'Please wait...');

nr = length(s);
delta_est=zeros(nr,2);
p = [n n]; % only the central (aliasing-free) part of NxN pixels is used for shift estimation
           % N*N���ص���ֻ���м䷢������Ĳ��ֲű�����λ�ƹ���
sz = size(s{1});
S1 = fftshift(fft2(s{1})); % Fourier transform of the reference image
                           %�Բο�ͼ�����2ά���ٸ���Ҷ�任
for i=2:nr
  waitbar(i/nr, h, 'Shift Estimation');
  S2 = fftshift(fft2(s{i})); % Fourier transform of the image to be registered
                             %�Խ�Ҫ������׼��ͼ����и���Ҷ�任
                               
  S2(S2==0)=1e-10;
  Q = S1./S2;
  A = angle(Q); % phase difference between the two images
                %����ͼ�����λ��
                
  % determine the central part of the frequency spectrum to be used
  %ȷ��Ҫʹ�õ�Ƶ���׵����Ĳ���
  beginy = floor(sz(1)/2)-p(1)+1;
  endy = floor(sz(1)/2)+p(1)+1;
  beginx = floor(sz(2)/2)-p(2)+1;
  endx = floor(sz(2)/2)+p(2)+1;
  
  % compute x and y coordinates of the pixels
  %�������ص��x��y����
  x = ones(endy-beginy+1,1)*[beginx:endx];
  x = x(:);
  y = [beginy:endy]'*ones(1,endx-beginx+1);
  y = y(:);
  v = A(beginy:endy,beginx:endx);
  v = v(:);

  % compute the least squares solution for the slopes of the phase difference plane
  % ������λ��ƽ��б�ʵ���С���˽�
  
  M_A = [x y ones(length(x),1)];
  r = M_A\v;
  delta_est(i,:) = -[r(2) r(1)].*sz/2/pi;
end

close(h);