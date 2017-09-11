function rec = interpolation(s,delta_est,phi_est,factor)
% INTERPOLATION - reconstruct a high resolution image using bicubic interpolation
%               - ��˫������ֵ�ؽ��߷ֱ���ͼ��
%    rec = interpolation(s,delta_est,phi_est,factor)
%    reconstruct an image with FACTOR times more pixels in both dimensions
%    using bicubic interpolation on the pixels from the images in S
%    (S{1},...) and using the shift and rotation information from DELTA_EST 
%    and PHI_EST
%    ͨ����S����ͼ���������Ϣ����˫������ֵ���Լ�����DELTA_EST��PHI_ESTЯ����λ�ƺ���ת��Ϣ
%    �ؽ����߱����ص�ͼ��FACTOR����

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%

n=length(s);
ss = size(s{1});
if (length(ss)==2) ss=[ss 1]; end
center = (ss+1)/2;
phi_rad = phi_est*pi/180;

% compute the coordinates of the pixels from the N images, using DELTA_EST and PHI_EST
%����DELTA_EST��PHI_EST�������Nͼ�����������
for k=1:ss(3) % for each color channel  ��ÿһ����ɫ�ź�ͨ��(ɫ��?)
  for i=1:n % for each image ��ÿһ��ͼ��
    s_c{i}=s{i}(:,:,k);
    s_c{i} = s_c{i}(:);
    r{i} = [1:factor:factor*ss(1)]'*ones(1,ss(2)); % 	 
    c{i} = ones(ss(1),1)*[1:factor:factor*ss(2)]; % create matrix with column indices �����������ľ���
    r{i} = r{i}-factor*center(1); % shift rows to center around 0   
    c{i} = c{i}-factor*center(2); % shift columns to center around 0 
    coord{i} = [c{i}(:) r{i}(:)]*[cos(phi_rad(i)) sin(phi_rad(i)); -sin(phi_rad(i)) cos(phi_rad(i))]; % rotate 
    r{i} = coord{i}(:,2)+factor*center(1)+factor*delta_est(i,1); % shift rows back and shift by delta_est
                                                                 % ����delta_est�����ƶ���
    c{i} = coord{i}(:,1)+factor*center(2)+factor*delta_est(i,2); % shift columns back and shift by delta_est
                                                                 % ����delta_est�����ƶ���
    rn{i} = r{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
    cn{i} = c{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
    sn{i} = s_c{i}((r{i}>0)&(r{i}<=factor*ss(1))&(c{i}>0)&(c{i}<=factor*ss(2)));
  end

  s_ = []; r_ = []; c_ = []; sr_ = []; rr_ = []; cr_ = [];
  for i=1:n % for each image ��ÿ��ͼ��
    s_ = [s_; sn{i}];
    r_ = [r_; rn{i}];
    c_ = [c_; cn{i}];
  end
  clear s_c r c coord rn cn sn
  
  h = waitbar(0.5, 'Image Reconstruction');
  set(h, 'Name', 'Please wait...');
  
  % interpolate the high resolution pixels using cubic interpolation 
  % ��������ֵ�Ը߷ֱ��ʵ����ص���в�ֵ
  rec_col = griddata(c_,r_,s_,[1:ss(2)*factor],[1:ss(1)*factor]','cubic'); % option QJ added to make it work 
  rec(:,:,k) = reshape(rec_col,ss(1)*factor,ss(2)*factor);
end
rec(isnan(rec))=0;

close(h);