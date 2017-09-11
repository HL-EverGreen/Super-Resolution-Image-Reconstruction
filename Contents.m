% SUPERRESOLUTION - Graphical User Interface for Super-Resolution Imaging
% SUPERRESOLUTION - ���ֱ��ʳ����ͼ���û�����
% This program allows a user to perform registration of a set of low 
% resolution input images and reconstruct a high resolution image from them.
% ����������ʹ�û���һϵ�еͷֱ��ʵ�����ͼ�����ؽ�һ���߷ֱ��ʵ�ͼ��
% Multiple image registration and reconstruction methods have been
% implemented. As input, the user can either select existing images, or 
% generate a set of simulated low resolution images from a high resolution 
% image. 
% ����ͼ����׼��ͼ���ؽ��ķ�����Ӧ�õ������뷽���û�����ѡ���Ѿ����ڵĵͷֱ���ͼ���������
% �߷ֱ���ͼ������һϵ��ģ��ͷֱ���ͼ��
% More information is available online:
% ������Ϣ�������ϲ�ѯ
% http://lcavwww.epfl.ch/software/superresolution
% If you use this software for your research, please also put a reference
% to the related paper 
% ����㽫�����������о�����ע���ο��˱����
% "A Frequency Domain Approach to Registration of Aliased Images            
% with Application to Super-Resolution" 
% Ƶ�򷽷�
% Patrick Vandewalle, Sabine Susstrunk and Martin Vetterli                  
% available at http://lcavwww.epfl.ch/reproducible_research/VandewalleSV05/ 

% v 1.0 - January 12, 2006 by Patrick Vandewalle, Patrick Zbinden and Cecilia Perez
% v 2.0 - November 6, 2006 by Patrick Vandewalle and Karim Krichane

%% -----------------------------------------------------------------------
% SUPERRESOLUTION - ���ֱ���ͼ���ؽ�ͼ���û�����
% Copyright (C) 2016 Laboratory of Zhejiang University 
% UPDATED From Laboratory of Audiovisual Communications (LCAV)
%

% Graphical User Interfaces
%   superresolution   - main program
%                     - ������
%   generation        - generate a set of low resolution shifted and 
%                       rotated images from a single input image
%                     -�������һ��ͼ�����һϵ�еͷֱ��ʵĴ�����ת��λ�Ƶ�ͼ��
%
% Image Registration  ͼ����׼ģ��
%   estimate_motion   - shift and rotation estimation using algorithm 
%                       by Vandewalle et al.
%                     -��Vandewalle�㷨����ͼ��λ�ƺ���ת�Ĺ���

%   estimate_rotation - rotation estimation using algorithm by Vandewalle et al.
%                     -��Vandewalle�㷨����ͼ����ת�Ĺ���

%   estimate_shift    - shift estimation using algorithm by Vandewalle et al.
%                     -��Vandewalle�㷨����ͼ��λ�ƵĹ���

%   keren             - estimate shift and rotation parameters 
%                       using Keren et al. algorithm
%                     -��Keren�㷨����λ�ƺ���ת�����Ĺ���

%   keren_shift       - estimate shift parameters using Keren et al. algorithm
%                     -��Keren�㷨����λ�Ʋ����Ĺ���

%   lucchese          - estimate shift and rotation parameters 
%                       using Lucchese and Cortelazzo algorithm
%                     -��Lucchese��Cortelazzo�㷨����λ�ƺ���ת�Ĺ���

%   marcel            - estimate shift and rotation parameters 
%                       using Marcel et al. algorithm
%                     -��Marcel�㷨����λ�ƺ���ת�����Ĺ���

%   marcel_shift      - estimate shift parameters using Marcel et al. algorithm
%                     -��Marcel�㷨����λ�Ʋ����Ĺ���
 
% Image Reconstruction  ͼ���ؽ�ģ��
%   interpolation     - reconstruct a high resolution image from a set of 
%                       low resolution images and their registration parameters
%                       using bicubic interpolation
%                     -ʹ��˫������ֵ��һϵ�еͷֱ���ͼ���Լ�������׼����Ϣ�����ؽ�

%   iteratedbackprojection - reconstruct a high resolution image from a set of 
%                       low resolution images and their registration parameters
%                       using iterated backprojection
%                       -����ͶӰ��

%   n_conv (and n_convolution) - reconstruct a high resolution image from a set
%                       of low resolution images and their registration parameters
%                       using algorithm by Pham et al.
%                       -Pham�㷨

%   papoulisgerchberg - reconstruct a high resolution image from a set of 
%                       low resolution images and their registration parameters
%                       using algorithm by Papoulis and Gerchberg
%                       -Papoulis��Gerchberg�㷨

%   pocs              - reconstruct a high resolution image from a set of 
%                       low resolution images and their registration parameters
%                       using POCS (projection onto convex sets) algorithm
%                     - ͹��ͶӰ����POCS)

%   robustSR          - reconstruct a high resolution image from a set of 
%                       low resolution images and their registration parameters
%                       using robust super-resolution algorithm by Zomet et al.
%                     - Zomet�Ľ�׳���ֱ����㷨

% Helper Functions    -����ģ��
%   applicability     - compute the applicability function in normalized 
%                       convolution method
%                     - �������ڹ淶������������Ժ���

%   c2p               - compute the polar coordinates of the pixels of an image
%                     - ����ͼ�����ص�ļ�����

%   create_images     - generate low resolution shifted and rotated images
%                       from a single high resolution input image
%                     - ���������һ���߷ֱ���ͼ�����һϵ�еͷֱ��ʵĴ���λ�ƺ���ת��ͼ��

%   generate_PSF      - generate the point spread function (PSF) matrix
%                     - ���� ����ɢ��������PSF)

%   lowpass           - low-pass filter an image by setting coefficients 
%                       to zero in frequency domain
%                     - ͨ������Ƶ����ϵ��Ϊ���ͼ����е�ͨ�˲�

%   robustnorm2       - function used in normalized convolution reconstruction
%                     - ���ڹ淶������ؽ��ĺ���

%   shift             - shift an image over a non-integer amount of pixels
%                     - ʹͼ����һ�����������ص�λ�ƣ�������λ�ƣ�

