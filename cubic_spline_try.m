%% cubic spline formula
clear all; clc

t=[0,4,8,12,16,20];
y=[0.7,0.9,0.9,0.7,0.3,0];
% A = [1,NaN,2];
% B = A(~isnan(A))

%% load

load('Lonlat_interp');

tnan=lon15mn; t=tnan(~isnan(tnan));
ynan=lat15mn; y=ynan(~isnan(ynan));
%%
%N=length(t); %number of points
N=168;
n=N-1; %number of subintervals

h=(t(N)-t(1))./n;

Trid=diag(4.*ones(1,n-1))+diag(ones(1,n-2),1)+diag(ones(1,n-2),-1);

for i=1:n-1
    z(i)=6/h.^2.*(y(i+2)-2.*y(i+1)+y(i));
end

z=z';
w=inv(Trid)*z(1:n-1);
sigma=[0;w;0];

for i=1:n
    d(i)=y(i);
    b(i)=sigma(i)/2;
    a(i)=(sigma(i+1)-sigma(i))/(6*h);
    c(i)=(y(i+1)-y(i))/h-h/6*(2*sigma(i)+sigma(i+1));
end

r=4; %number of intervals
hh=h/r; %step size of subsubintervals

x=t(1):hh:t(N);

for i=1:n
    for j=r*(i-1)+1:r*i
        s(j)=a(i)*(x(j)-t(i))^3+b(i)*(x(j)-t(i))^2+c(i)*(x(j)-t(i))+d(i);
    end
end

s(r*n+1)=y(N);
%% 
plot(t,y,'o');
hold on
plot(x,s,'x');
axis([-82 -78 -10 -5]);

%%

