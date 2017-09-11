function [rot_angle, c] = estimate_rotation(a,dist_bounds,precision)
% ESTIMATE_ROTATION - rotation estimation using algorithm by Vandewalle et al.
%                  ��Vandewalle�㷨������ת
%    [rot_angle, c] = estimate_rotation(a,dist_bounds,precision)
%    DIST_BOUNDS gives the minimum and maximum radius to be used
%    DIST_BOUNDS�ṩ��ʹ�õ�����С�����뾶����Χ��
%    PRECISION gives the precision with which the rotation angle is computed
%    PRECISION�ṩ�˼�����ת�Ƕȵľ���
%    input images A are specified as A{1}, A{2}, etc.

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%

h = waitbar(0, 'Rotation Estimation');  %����������
set(h, 'Name', 'Please wait...');   

nr = length(a); % number of inputs ���������
d = 1*pi/180; % width of the angle over which the average frequency value is computed �ǿ�ȣ��ڴ˻����Ͻ���ƽ��Ƶ��ֵ����
s = size(a{1})/2;
center = [floor(s(1))+1 floor(s(2))+1]; % center of the image and the frequency domain matrix
                                        % ͼ���е� �� Ƶ�������
x = ones(s(1)*2,1)*[-1:1/s(2):1-1/s(2)]; % X coordinates of the pixels  ���ص�X����
y = [-1:1/s(1):1-1/s(1)]'*ones(1,s(2)*2); % Y coordinates of the pixels  ���ص�Y����
x = x(:);
y = y(:);
[th,ra] = cart2pol(x,y); % polar coordinates of the pixels  ���صļ�����

%***********************************************************
DB = (ra>dist_bounds(1))&(ra<dist_bounds(2));
%***********************************************************
th(~DB) = 1000000;
[T, ix] = sort(th); % sort the coordinates by angle theta      ��������

st = length(T);

%% compute the average value of the fourier transform for each segment
%  ����ÿһ���ָ���Ҷ�任��ƽ��ֵ
I = -pi:pi*precision/180:pi;
J = round(I/(pi*precision/180))+180/precision+1;  %round��������������ȡ��
for k = 1:nr
    waitbar(k/(2*nr), h, 'Rotation Estimation');  %������
    A{k} = fftshift(abs(fft2(a{k}))); % Fourier transform of the image  
                                      %fft2 2ά��ɢ����Ҷ���ٱ任
                                      %fftshift����ʹ�ã�ʹ��fft�ó���������Ƶ�ʶ�Ӧ
                                     
    ilow = 1;
    ihigh = 1;
    ik = 1;
    for i = 1:length(I)
        ik = ilow;
        while(I(i)-d > T(ik))
            ik = ik + 1;
        end;

        ilow = ik;
        ik = max(ik, ihigh);
        while(T(ik) < I(i)+d)
            ik = ik + 1;
            if (ik > st | T(ik) > 1000)
                break;
            end;
        end;
        ihigh = ik;
        if ihigh-1 > ilow
            h_A{k}(J(i)) = mean(A{k}(ix(ilow:ihigh-1)));
        else
            h_A{k}(J(i)) = 0;
        end
    end;
    v = h_A{k}(:) == NaN;
    h_A{k}(v) = 0;
end

% compute the correlation between h_A{1} and h_A{2-4} and set the estimated rotation angle 
% to the maximum found between -30 and 30 degrees
% ����h_A{1}��h_A{2-4}�Ĺ��������ù�����ת��Ϊ-30�ȵ�30���ڵ����ֵ��Ӧ�Ķ���

H_A = fft(h_A{1});
rot_angle(1) = 0;
c{1} = [];
for k = 2:nr
  H_Binv = fft(h_A{k}(end:-1:1));
  H_C = H_A.*H_Binv;
  h_C = real(ifft(H_C));
  [m,ind] = max(h_C(150/precision+1:end-150/precision));
  rot_angle(k) = (ind-30/precision-1)*precision;
  c{k} = h_C;
end

close(h);
