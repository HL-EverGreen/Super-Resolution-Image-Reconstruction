function delta_est = marcel_shift(s,M)
% MARCEL_SHIFT shift estimation using algorithm by Marcel et al.
%              ��Marcel�㷨����λ��
%    [delta_est, phi_est] = marcel(s,M)
%    motion estimation algorithm implemented from the paper by Marcel et al.
%    horizontal and vertical shifts DELTA_EST are estimated from the input 
%    images S (S{1},etc.). For the shift estimation, the Fourier transform 
%    images are interpolated by a factor M to increase precision.
%    ���������ͼ�����S����ˮƽ����ֱ�����λ��DELTA_EST
%    ��λ�ƹ��Ʒ��棬���Ը���Ҷ�任���ͼ���ò���M���в�ֵ����߾��ȡ�

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%                    

nr=length(s);
S = size(s{1});
if (nargin==1)
    M = 10; % magnification factor to have higher precision
            % Ϊ���ߵľ����趨�Ŵ�ϵ��
end

phi_est = zeros(1,nr);
r_ref = S(1)/2/pi;
IMREF = fft2(s{1});
IMREF_C = abs(fftshift(IMREF));
IMREF_P = c2p(IMREF_C);
IMREF_P = IMREF_P(:,round(0.1*r_ref):round(1.1*r_ref)); % select only points with radius 0.1r_ref<r<1.1r_ref
                                                        % ѡ�������⾶�ֱ�Ϊ0.1r_ref��1.1r_ref�Ļ��������ڵĵ�
IMREF_P_ = fft2(IMREF_P);
for i=2:nr
    % shift estimation    λ�ƹ���
    IM = fft2(s{i});
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
