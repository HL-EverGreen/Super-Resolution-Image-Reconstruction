function [delta_est, phi_est] = marcel(s,M)
% MARCEL - estimate shift and rotation parameters using Marcel et al. algorithm
%          ��Marcel�㷨����λ�ƺ���ת�����Ĺ���
%    [delta_est, phi_est] = marcel(s,M)
%    horizontal and vertical shifts DELTA_EST and rotations PHI_EST are 
%    estimated from the input images S (S{1},etc.). For the shift and 
%    rotation estimation, the Fourier transform images are interpolated by 
%    a factor M to increase precision
%    ���������ͼ�����S����ˮƽ�������ֱ����λ��DELTA_EST�����Լ���תPHI_EST����Ĺ��ơ�
%    Ϊ�����ת��λ�ƵĹ��ƾ��ȣ����Ը���Ҷ�任���ͼ���ò���M���в�ֵ

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%
nr=length(s);
S = size(s{1});
if (nargin==1)
    M = 10; % magnification factor to have higher precision
            % ���÷Ŵ�ϵ������߾���
end

% if the image is not square, make it square (rest is not useful for rotation estimation anyway)
% ���ͼƬ���������εģ���ʹ���Ϊ�����Σ���Ϊ���ಿ�ֶ�����ת����û���ô���
if S(1)~=S(2)
    if S(1)>S(2)
        for i=1:length(s)
           s{i} = s{i}(floor((S(1)-S(2))/2)+1:floor((S(1)-S(2))/2)+S(2),:);
        end
    else
        for i=1:length(s)
           s{i} = s{i}(:,floor((S(2)-S(1))/2)+1:floor((S(2)-S(1))/2)+S(1));
        end
    end
end

phi_est = zeros(1,nr);
r_ref = S(1)/2/pi;
IMREF = fft2(s{1});
IMREF_C = abs(fftshift(IMREF));
IMREF_P = c2p(IMREF_C);
IMREF_P = IMREF_P(:,round(0.1*r_ref):round(1.1*r_ref)); % select only points with radius 0.1r_ref<r<1.1r_ref
                                                        % ѡ���ڻ����ڵĵ㣨0.1~1.1)
IMREF_P_ = fft2(IMREF_P);
for i=2:nr
    % rotation estimation  ��ת����
    IM = abs(fftshift(fft2(s{i})));
    IM_P = c2p(IM);
    IM_P = IM_P(:,round(0.1*r_ref):round(1.1*r_ref)); % select only points with radius 0.1r_ref<r<1.1r_ref
    IM_P_ = fft2(IM_P);
    psi = IM_P_./IMREF_P_;
    PSI = fft2(psi,M*S(1),M*S(2));
    [m,ind] = max(PSI);
    [mm,iind] = max(m);
    phi_est(i) = (ind(iind)-1)*360/S(1)/M;

    % rotation compensation, required to estimate shifts  ����λ�ƵĹ��Ʋ�����ת����
    s2{i} = imrotate(s{i},-phi_est(i),'bilinear','crop');

    % shift estimation   λ�ƹ���
    IM = fft2(s2{i});
    psi = IM./IMREF;
    PSI = fft2(psi,M*S(1),M*S(2));
    [m,ind] = max(PSI);
    [mm,iind] = max(m);
    delta_est(i,1) = (ind(iind)-1)/M;
    delta_est(i,2) = (iind-1)/M;
    if delta_est(i,1)>S(1)/2
        delta_est(i,1) = delta_est(i,1)-S(1);
    end
    if delta_est(i,2)>S(2)/2
        delta_est(i,2) = delta_est(i,2)-S(2);
    end
end

% Sign change in order to follow the project standards  
% Ϊ�˰�����Ŀ�ı�׼���õ��任
delta_est = -delta_est;
