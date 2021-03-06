function T_Mat=TMatConstruction(movies,Resol_x,Resol_y,Resol_t)
%TMATCONSTRUCTION Summary of this function goes here
%  Detailed explanation goes here
[num_of_movies movies_info]=GetMoviesInfo(movies);

T_Mat=zeros(3,6);
for i=1:3
    ResolRatioT(i)=Resol_t/movies_info(i).NumFrames;
    ResolRatioX(i)=Resol_x/movies_info(i).Width;
    ResolRatioY(i)=Resol_y/movies_info(i).Height;
end

%[ Resolution Ratio between low space and high space(x), Shift in the low space (x)...]
T_Mat(1,:)=[ResolRatioX(1),0,ResolRatioY(1),0,ResolRatioT(1),0];
T_Mat(2,:)=[ResolRatioX(2),0,ResolRatioY(2),0,ResolRatioT(2),1/7];
T_Mat(3,:)=[ResolRatioX(3),0,ResolRatioY(3),0,ResolRatioT(3),2/7];

