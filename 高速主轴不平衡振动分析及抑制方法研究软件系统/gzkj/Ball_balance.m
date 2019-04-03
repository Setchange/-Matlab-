% ��������[f,J,outpara] = Ball_balance(x0,delta,k,BF,Speed) �����򼸺ι�ϵ����ƽ���ϵ������
% ���룺 x0 = {Uk Vk deltaok deltaik}������������delta ������Ȧ�����λ��������k����k�������壻
%          BF = 1��ѡ��ǰ���HYHK61914��Speed��ת�٣�r/min����
% �����f ��4X1����ֵ�� J��4X4�ſ˱Ⱦ���outpara�����������
function [f,J,outpara] = Ball_balance(x0,delta,k,BF,Speed) 
% load('E:\matlab GUI\gzkj\chuandishuju\chuandishuju.mat');
global Di1 Do1 D1 N1 theta1 
N=N1;
Di=Di1;
Do=Do1;
D=D1;
theta=theta1;
% % ѡ�����
% if BF == 1
%     Di=70e-3;                                           % inner d ��Ȧ�ھ�
%     Do=100e-3;                                          % outer d ��Ȧ�⾶
%     D=6.35e-3;                                          % diameter of the bearing ball ������ֱ��
%     N = 32;                                             % ����������
%     theta=25*pi/180;                                    % the initial contact angle of the bearing 914 ��ʼ�Ӵ���25��
% %       N =  14;
% %       Di = 25e-3;
% %       Do = 52e-3;
% %       D = 7e-3;
% %       theta = 25*pi/180;
%  else
%     Di=55e-3;                                           % inner d
%     Do=80e-3;                                           % outer d
%     D=5.56e-3;                                          % diameter of the bearing ball
%     N = 30;
%     theta=-25*pi/180;                                    % the initial contact angle of the bearing 911 
% %       N =  14;
% %       Di = 25e-3;
% %       Do = 52e-3;
% %       D = 7e-3;
% %       theta = -25*pi/180;
% end
%���㳣��
% fi = 0.515; 
% fo = 0.514;
% ri = fi*D;
% ro = fo*D;
ri=3.524e-3;                                        % the radii of the inner ring groove    ��Ȧ���ʰ뾶
ro=3.588e-3;                                        % the radii of the outer ring groove     ��Ȧ���ʰ뾶
Dm=1/2*(Di+Do);                                     % pitch diameter = inner diameter +  diameter :��Բֱ��
Ea=3.15e11;                                         % Young's modulus of the bearing ball          ����������ģ��
ua=0.26;                                            % poission ratio of the bearing ball           �����岴�ɱ�
Eb=2.08e11;                                         % Young's modulus of inner ring or outer ring   ����Ȧ����ģ��
ub=0.30;                                            % poission ratio of inner ring or outer ring    ����Ȧ���ɱ�
p0=7800;                                            % density of the ball  �ܶ�                                                                                
% 
b = -1;
deltax = delta(1);deltay = delta(2);deltaz = delta(3);gamay = delta(4);gamaz = delta(5); % δ֪��      % �������Ȧ������λ�Ʒ���
lamda=D/Dm;                                                                  % ����
fo=ro/D; fi=ri/D;                                                            % ����Ȧ�������ʰ뾶ϵ��
BD=(fo+fi-1)*D;                                                              % �˶�����ǰ����Ȧ������������֮��ľ���
ric=Dm/2+(fi-0.5)*D*cos(theta);                                              % ����
Ep=2/((1-ua^2)/Ea+(1-ub^2)/Eb);                                              % ����
Uik=BD*sin(theta)+deltax-gamaz*ric*cos(b*pi/N+2*pi*k/N)+gamay*ric*sin(b*pi/N+2*pi*k/N);
Vik=BD*cos(theta)+deltay*cos(b*pi/N+2*pi*k/N)+deltaz*sin(b*pi/N+2*pi*k/N);% δ֪��  % ƽ�������Ȧ������������֮������򡢾������
x = x0; Uk=x(1);Vk=x(2);deltaok=x(3);deltaik=x(4);                           %  x0 = {Uk Vk deltaok deltaik}����������
%�м䣨����������,����  
thetaik = asin((Uik-Uk)/((fi-0.5)*D+deltaik));                                                                                         
thetaok = asin(Uk/((fo-0.5)*D+deltaok));                                     % thetaik��thetaok ������������Ȧ�����Ӵ���                                   
gamai=D*cos(thetaik)/Dm; gamao=D*cos(thetaok)/Dm;                            % ����
% �� Kik������������Ȧ�����ĽӴ�ϵ��       Qik������������Ȧ�����Ӵ���   
Rx=D/2*(1-gamai);Ry=D*fi/(2*fi-1);Rxy=Rx*Ry/(Rx+Ry);
Eik=1.0003+0.5968*(Rx/Ry);FF=1.5277+0.6023*log(Ry/Rx);kapa=1.0339*(Ry/Rx)^0.6360;
Kik=pi*kapa*Ep/(3*FF)*sqrt(2*Eik*Rxy/FF);  Qik=Kik*deltaik^1.5;aik = (6*kapa^2*Eik*Rxy*Qik)^(1/3);
% �� Kok �� Qok
Rx=D*fo/(2*fo-1);Ry=D/2*(1+gamao);Rxy=Rx*Ry/(Rx+Ry);
Eok=1.0003+0.5968*(Rx/Ry);FF=1.5277+0.6023*log(Ry/Rx);kapa=1.0339*(Ry/Rx)^0.6360;
Kok=pi*kapa*Ep/(3*FF)*sqrt(2*Eok*Rxy/FF);  Qok=Kok*deltaok^1.5;aok = (6*kapa^2*Eok*Rxy*Qok)^(1/3);
% �����������
Icontrl = Qik*aik*Eik*cos(thetaik-thetaok)>Qok*aok*Eok;                                                   % �ж�Ϊ�ڹ������                  

% -------- ������Ȧ���������Fck Mgk
if Icontrl
    OmegaE_Omegak = (cos(thetaik - thetaok) - lamda * cos(thetaok))/(1 + cos(thetaik - thetaok)); % E/k  �����幫ת�ٶ��������Ȧ���ٶȱ�
    alphak = atan(sin(thetaik)/(cos(thetaik) - lamda));                                                  % ��̬��
    lamdaok = 1;lamdaik = 1;                                                                             % �������ϵ��
else
    OmegaE_Omegak = (1-lamda*cos(thetaik))/(1+cos(thetaik-thetaok));
    alphak = atan(sin(thetaok)/(cos(thetaok)+lamda)); 
    lamdaok = 2;lamdaik = 0;
end

OmegaB_Omegak = -1/(lamda*cos(alphak)*((cos(thetaok)+tan(alphak)*sin(thetaok))/(1+lamda*cos(thetaok))+(cos(thetaik)+tan(alphak)*sin(thetaik))/(1-lamda*cos(thetaik))));% B/k 
Omega = 2*pi* Speed/60;                                                                                   % ����ת�����ٶ�  
Fck = 1/12*pi*p0*D^3*Dm*Omega^2*OmegaE_Omegak^2;                                                          % �������������
Mgk = 1/60*pi*p0*D^5*Omega^2*OmegaB_Omegak*OmegaE_Omegak*sin(alphak);                                     % ���������������
lcondk = Uik^2+(Vik-(fo-0.5)*D-Kok^(-2/3)*Fck^(2/3))^2<=((fi-0.5)*D)^2;                                   % ������������Ȧ
%%��������
% ���η��� 
eq1 = (Uik-Uk)^2+(Vik-Vk)^2-((fi-0.5)*D+deltaik)^2;
eq2 = Uk^2+Vk^2-((fo-0.5)*D+deltaok)^2;
% ������ƽ�ⷽ��
eq3 = Kok*deltaok^1.5*Vk/((fo-0.5)*D+deltaok)-lamdaok*Mgk/D*Uk/((fo-0.5)*D+deltaok)-Kik*deltaik^1.5*(Vik-Vk)/((fi-0.5)*D+deltaik)+lamdaik*Mgk/D*(Uik-Uk)/((fi-0.5)*D+deltaik)-Fck;
eq4 = Kok*deltaok^1.5*Uk/((fo-0.5)*D+deltaok)+lamdaok*Mgk/D*Vk/((fo-0.5)*D+deltaok)-Kik*deltaik^1.5*(Uik-Uk)/((fi-0.5)*D+deltaik)-lamdaik*Mgk/D*(Vik-Vk)/((fi-0.5)*D+deltaik);
if lcondk   % ������������Ȧ
    Mgk = 0;deltaok = (Fck/Kok)^(2/3); 
    Uk = 0; Vk = (fo-0.5)*D+deltaok;  deltaik = 0; 
    eq1=0;  eq2=0;eq3 = 0;eq4 = 0;
end
% �ſ˱Ⱦ���J
a11=-2*(Uik-Uk);a12=-2*(Vik-Vk);a13=0;a14=-2*((fi-0.5)*D+deltaik);
a21=2*Uk;a22=2*Vk;a23=-2*((fo-0.5)*D+deltaok);a24=0;
a31=-Mgk/D*(lamdaok/((fo-0.5)*D+deltaok)+lamdaik/((fi-0.5)*D+deltaik));a32=Kok*deltaok^1.5/((fo-0.5)*D+deltaok)+Kik*deltaik^1.5/((fi-0.5)*D+deltaik);
a33=3/2*Kok*deltaok^0.5*Vk/((fo-0.5)*D+deltaok)-Kok*deltaok^1.5*Vk/((fo-0.5)*D+deltaok)^2+lamdaok*Mgk/D*Uk/((fo-0.5)*D+deltaok)^2;
a34=-(3/2*Kik*deltaik^0.5*(Vik-Vk)/((fi-0.5)*D+deltaik)-Kik*deltaik^1.5*(Vik-Vk)/((fi-0.5)*D+deltaik)^2+lamdaik*Mgk/D*(Uik-Uk)/((fi-0.5)*D+deltaik)^2);
a41=Kok*deltaok^1.5/((fo-0.5)*D+deltaok)+Kik*deltaik^1.5/((fi-0.5)*D+deltaik);a42=Mgk/D*(lamdaok/((fo-0.5)*D+deltaok)+lamdaik/((fi-0.5)*D+deltaik));
a43=3/2*Kok*deltaok^0.5*Uk/((fo-0.5)*D+deltaok)-Kok*deltaok^1.5*Uk/((fo-0.5)*D+deltaok)^2-lamdaok*Mgk/D*Vk/((fo-0.5)*D+deltaok)^2;
a44=-(3/2*Kik*deltaik^0.5*(Uik-Uk)/((fi-0.5)*D+deltaik)-Kik*deltaik^1.5*(Uik-Uk)/((fi-0.5)*D+deltaik)^2-lamdaik*Mgk/D*(Vik-Vk)/((fi-0.5)*D+deltaik)^2);
% ��� J �� f
% format long
J=[a11,a12,a13,a14;a21,a22,a23,a24;a31,a32,a33,a34;a41,a42,a43,a44];f=[eq1;eq2;eq3;eq4];
aijk = [a31,a32,a33,a34,a41,a42,a43,a44];
% outparasym = '14 + 8 parasyms -----  [Kok Kik Uk Vk Uik Vik deltaok deltaik lamdaoik lamdaik thetaok thetaik alphak phik aijk] -------';
outpara  = [Kok Kik Uk Vk Uik Vik deltaok deltaik lamdaok lamdaik thetaok thetaik alphak  Mgk Fck aijk]; 


