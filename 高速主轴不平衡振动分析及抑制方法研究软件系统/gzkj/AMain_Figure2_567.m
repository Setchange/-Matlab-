% ������й�������ز�������λ�õĶ�ά�仯���ߡ�
% ������ X�����غɴ�СΪ300N��Y�����غɴ�С�ֱ�Ϊ0��100N��200N��300N�������Ȧת��Ϊ10000 r/min����в�ͬ���������λ�ýǵı仯��ϵ���£�������Ȧ���ƣ�
clear;close all;clc
global  test iter
format long
BF = 1;                              % ѡ�����
iter = zeros(1,6);
feps = 1e-6;maxit = 200;
b=-1;N = 32;k = (1:N)';              % ����
phi = (b*pi/N+2*pi*k/N);             % ��k���������λ�ý�
phid = (b*pi/N+2*pi*k/N)*180/pi;     % ��λ����
i = 0;preload = zeros(5,1);
Prefy = 0:100:300;                   % Y�����غɴ�С  0 100 200 300
Prefx = 300;                         % X�����غ�
Premz = -linspace(0,6,length(Prefy));
preload(1) = Prefx;
Speedn = 0:5000:15000;
Speedn = 10000;

% for 
    Speed = Speedn    
    i = i+1;j = 0;
    for Preload = Prefy
        j = j + 1;
        preload(2) = Preload;
        preload(5) = Premz(j);
        [predisplacement,Fiv1,DFiv1,iteri,flagi] = Bearing_of_Stiffness(preload,Speed,feps,maxit,BF);        
        test1 = test{1};
        test2 = test1{2};
        for i = k;
%             Ko(i,j) = test2(i,1)*(1e-6)^1.5;  % �Ӵ�ϵ��N/um^1.5
%             Ki(i,j) = test2(i,2)*(1e-6)^1.5;
            Ko(i,j) = test2(i,1);  % �Ӵ�ϵ��N/um^1.5
            Ki(i,j) = test2(i,2);
            U = test2(i,3);
            V = test2(i,4);
            Ui = test2(i,5);
            Vi = test2(i,6);
%             deltao(i,j) = test2(i,7)*1e6;    % �Ӵ�����/um
%             deltai(i,j) = test2(i,8)*1e6;
            deltao(i,j) = test2(i,7);    % �Ӵ�����/um
            deltai(i,j) = test2(i,8);
            lamdao(i,j) = test2(i,9);
            lamdai(i,j) = test2(i,10);
            % �Ƕ�/��
            thetao(i,j) = test2(i,11)*180/pi;
            thetai(i,j) = test2(i,12)*180/pi;
            alpha(i,j) = test2(i,13)*180/pi;
            Mg(i,j) = test2(i,14);         % N.mm
            Fc(i,j) = test2(i,15);
            sxi(i,j) = predisplacement(1)*1e6; % /um
            syi(i,j) = predisplacement(2)*1e6;
            Qi(i,j) = Ki(i,j).*deltai(i,j).^1.5;
            Qo(i,j) = Ko(i,j).*deltao(i,j).^1.5;
            % �ն� / N/um
        end
    end
     %%
    xlim = 500;
%   hx = 0.35;hy = 0.35;xh = 0.1;yh = xh;
%   figure('units','normalized','position',[xh,yh,hx,hy]) 

    figure('NumberTitle','off','Name','��������λ�ýǵı仯����ͼ');
    subplot(3,2,1)
    plot(phid,Mg(:,1),'-',phid,Mg(:,2),'*-',phid,Mg(:,3),'--',phid,Mg(:,4),'o-')
    h=legend('Fy=0','Fy=100N','Fy=200N','Fy=300N',1);
    set(h,'box','off');
    xlabel('\phi / \circ');
    ylabel('M_g / N.m');   
    title('����������λ�ýǵı仯');
    set(gca,'Xlim',[0 xlim])

    subplot(3,2,2)
    plot(phid,Fc(:,1),'-',phid,Fc(:,2),'*-',phid,Fc(:,3),'--',phid,Fc(:,4),'o-')
    h=legend('Fy=0','Fy=100N','Fy=200N','Fy=300N',1);
    set(h,'box','off');
    xlabel('\phi / \circ');
    ylabel('F_c / N')    
    title('����������λ�ýǵı仯');
    set(gca,'Xlim',[0 xlim])    
    %%    
%     figure('units','normalized','position',[xh,yh,hx,hy])      
    subplot(3,2,3);  
    plot(phid,Qi(:,1),'-',phid,Qi(:,2),'*-',phid,Qi(:,3),'--',phid,Qi(:,4),'o-')
    h=legend('Fy=0','Fy=100N','Fy=200N','Fy=300N',1);
    set(h,'box','off');
    xlabel('\phi / \circ');
    ylabel('Q_i / N')  
    title('����������Ȧ�Ӵ�����λ�ýǵı仯')
    set(gca,'Xlim',[0 xlim])
    subplot(3,2,4);
    plot(phid,Qo(:,1),'-',phid,Qo(:,2),'*-',phid,Qo(:,3),'--',phid,Qo(:,4),'o-')
    legend('Fy=0','Fy=100N','Fy=200N','Fy=300N')
    h=legend('Fy=0','Fy=100N','Fy=200N','Fy=300N',1);
    set(h,'box','off');
    xlabel('\phi / \circ');
    ylabel('Q_o / N') 
    title('����������Ȧ�Ӵ�����λ�ýǵı仯')
    set(gca,'Xlim',[0 xlim])
    
%%         
%     figure('units','normalized','position',[xh,yh,hx,hy])     
    subplot(3,2,5)
    plot(phid,thetai(:,1),'-',phid,thetai(:,2),'*-',phid,thetai(:,3),'--',phid,thetai(:,4),'o-')
    h=legend('Fy=0','Fy=100N','Fy=200N','Fy=300N',1);
    set(h,'box','off');
    xlabel('\phi / \circ');
    ylabel('\alpha_i / \circ')
     title('����������Ȧ�Ӵ�����λ�ýǵı仯')
    set(gca,'Xlim',[0 xlim])
    subplot(3,2,6)
    plot(phid,thetao(:,1),'-',phid,thetao(:,2),'*-',phid,thetao(:,3),'--',phid,thetao(:,4),'o-')
    h=legend('Fy=0','Fy=100N','Fy=200N','Fy=300N',1);
    set(h,'box','off');
    xlabel('\phi / \circ');
    ylabel('\alpha_o / \circ')
    title('����������Ȧ�Ӵ�����λ�ýǵı仯')
    set(gca,'Xlim',[0 xlim])
% %%     
%     figure()  % 
%     plot(phid,alpha(:,1),'-.',phid,alpha(:,2),'.-',phid,alpha(:,3),'--',phid,alpha(:,4),'*-')
%     legend('Fy=0','Fy=100N','Fy=200N','Fy=300N')
%     xlabel('\phi / \circ');
%     ylabel('\alpha / \circ')
%     set(gca,'Xlim',[0 550])
    
    
    

    