%% Betatron�����Դͬ����ĳ�����ֵģ�� %%
clc;clear;
tic()
%% Betatron�����Դ����������Ϊ1-100keV��������ϵͳ����
E = linspace(1,100,100);
lambda = linspace(1,100,100);
k = linspace(1,100,100);
for m = 1:100
    lambda(m) = (1.241E-6)/E(m); % mm ����=hc/E
    k(m) = 2*pi/lambda(m); % /mm ��ʸ
end
r1 = 1000; % mm ���
r2 = 1000; % mm ���
M = (r1+r2)/r1; % �Ŵ���
z = r2/M; % ���Դ��Ч��ƽ�й�ʱ�ĵ�Ч���

%% ��ƽ��
D = 0.1; % mm Բ���뾶
h = 1; % mm Բ���߶�
lx = 2; % mm ȡ������
ly = 0.2; % mm ȡ�����
N = 500; % ȡ������
% ��Բ��������Ϊԭ�㣬����ֱ������ϵ
x0 = linspace(-lx/2,lx/2,N);
y0 = linspace(-ly/2,ly/2,N);
th = linspace(0,0,N);
for m = 1:N
    if(abs(y0(m))<= D/2)
        th(m) = 2*sqrt((D/2).^2-(y0(m)).^2); % �����������Ĺ�ϵ
    end
end
th = th';
P = zeros(N);
for n = 1:N
    if(abs(x0(n)) <= h/2)
        P(:,n) = th; % ������ƽ��
    end
end
%figure;imagesc(x0,y0,P)
%plot(y0,th)

% Index of Refraction = (1-delta)-i(beta)
% C7H5N3O6 Density=1.654 @PE = 10keV
delta = 3.51828226E-06;
beta = 6.33161923E-09; 
for m = 1:100
    mu(:,:,m) = (k(m)*beta).*P; % ����ϵ��
    phi(:,:,m) = (-k(m)*delta).*P; % ����ϵ��
end
u0 = exp(-mu+i*phi); % ��ƽ��ĸ����
I0 = zeros(N);
for m = 1:100
    U_0(:,:,m) = fftshift(fft2(u0(:,:,m))); % Fourier�任���Ƶ���ϵ���ƽ��
    I0 = I0 + abs(u0(:,:,m)).^2; % ��ƽ���ǿ
end
figure('NumberTitle','off','Name','��ƽ���ǿ');imagesc(x0,y0,I0)
figure('NumberTitle','off');plot(y0,I0(:,N/2));grid on;title('��ƽ����y���ǿ�仯����')

%% ϵͳ�������
% Ƶ������
x1 = linspace(-N/2/lx,N/2/lx,N);
y1 = linspace(-N/2/ly,N/2/ly,N);
y1 = y1'; % or [x y] = meshgrid(x1,y1)
for m = 1:100
    H(:,:,m) = exp(i*k(m)*z-i*pi*lambda(m)*z*(x1.^2+y1.^2));
end

%% ��ƽ��
U_1 = U_0.*H; % Fourier�任���Ƶ���ϵ���ƽ��
I1 = zeros(N);
for m = 1:100
    u1(:,:,m) = ifft2(U_1(:,:,m)); % ��ƽ��ĸ����
    I1 = I1 + abs(u1(:,:,m)).^2; % ��ƽ���ǿ
end
figure('NumberTitle','off','Name','�����ǿ�Ա�');imagesc(x0*M,y0*M,I1)
figure('NumberTitle','off');plot(y0*M,I1(:,N/2));grid on;title('��ƽ����y���ǿ�仯����')
toc()
%{
figure('NumberTitle','off','Name','�����ǿ�Ա�')
subplot(2,2,1)
imagesc(x0,y0,I0)
subplot(2,2,2)
plot(y0,I0(:,N/2))
subplot(2,2,3)
imagesc(x0*M,y0*M,I1)
subplot(2,2,4)
plot(y0*M,I1(:,N/2))
%}