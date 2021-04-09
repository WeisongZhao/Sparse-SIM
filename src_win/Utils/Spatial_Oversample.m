function y=Spatial_Oversample(SIMmovie,n)
if nargin < 2 || isempty(n)
    n=2;
end
[sx,sy,~] = size(SIMmovie);
ind_down_y1 = n:n:sy*n;
ind_down_x1 = n:n:sx*n;
y(ind_down_x1,ind_down_y1,:) =SIMmovie;