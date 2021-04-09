function Ipsf=Generate_PSF(pixel,lamda,n,NA,z)

sin2=((1-(1-NA^2))/2);
u=8*pi*z*sin2/lamda;
h=@(r,p) 2*exp((1i*u*(p.^2))/2).*besselj(0,2*pi*r*NA/lamda.*p);
x=-n*pixel:pixel:n*pixel;
[X,Y]=meshgrid(x,x);
[~,s1]=cart2pol(X,Y);
idx=s1<=1;
IP=zeros(size(X));
k=1;
progressbar('Pre-operation')
for f=1:1:size(s1)
    for j=1:1:size(s1)
        if idx(f,j)==0
            IP(f,j)=0;
        else
            o=s1(idx);
            r=o(k);
            k=k+1;
            II=@(p)h(r,p);
            IP(f,j)=integral(II,0,1);
        end
    end
    progressbar(f/size(s1,1))
end
Ipsf=abs(IP.^2);
Ipsf=Ipsf./sum(sum( Ipsf));