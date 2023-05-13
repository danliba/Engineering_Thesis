%%%%%%%%%%%%%%%%%%%%%
clear all


fn = 'SSH&SSTactual.nc';


yrstart=2020;
yrend=[];
a=100; %distancia en millas nauticas

%%%%%%%%%%%%%%%%%%%%%

[SHHw,Tempw,ycat,wcat] = daily_to_weekly(fn,yrstart);

% load climatology
load('SSHSemanalCLIM.mat')
load('puertos')


time=ncread(fn,'time')./24;
lonsact=ncread(fn,'longitude');
latsact=ncread(fn,'latitude');

% convert single variables, time lon lat to double
time=double(time);
lon=double(lonsact);
lat=double(latsact);

% convert julian date of SSH to MATLAB julian date
time=time+datenum(1950,1,1,0,0,0);
[yr,mo,da,hr,mi,se]=datevec(time);

if isempty(yrend) 
t= datetime(yrstart,01,01):datetime(yr(end),mo(end),da(end));
w = week(t);

WSSH=w;
WSSH=WSSH';

yrst=yrstart;
west=1;
yren=yr(end);
ween=WSSH(end);
ween0=ween;

[timesWeek] = weekly_time(yrst,yren,ween);

end 

if yrend>0
    
rtx=find(yr == yrend & mo==12);
tx=rtx(end);

t= datetime(yrstart,01,01):datetime(yrend,mo(tx),da(tx));
w = week(t);

WSSH=w;
WSSH=WSSH';

yrst=yrstart;
west=1;
yren=yrend;
ween=WSSH(end);
ween0=ween;

[timesWeek] = weekly_time(yrst,yren,ween);

end
%%
iter=0;
% figure

for iy=yrst:1:yren
    % if iy is greater than yrst, then let most is 1
    if iy>yrst
        west=1;
    end
    % in case iy is the last year then  then let moen to be kept value, moen0,
    if iy==yren
        ween=ween0;
    else % otherwise, moen is 12
        ween=53;
    end
   
    % start the loop for month
    for iw=west:1:ween
        % display the month under processing
        disp(['Year: ' num2str(iy) ' Week: ' num2str(iw)])
        % find the index of CHL data at iy=yr and im=mo
        indx=find(ycat==iy & wcat==iw);
        % check whether index is unique and found
        if length(indx)>1
            disp('index has more than two entries')
            datestr(time(indx))
        elseif isempty(indx)==1
            error('there is no sal data')
        end
    
                % update the iter by adding 1
        iter=iter+1;
        % get sal monthly data
        SSHsanom=(SHHw(:,:,indx)-SSHweeklyclim(:,:,iw))*100;
        SSTsanom=Tempw(:,:,indx)-SSTweeklyclim(:,:,iw);
        
     
        [lonki, latki ,pathdataSSH, disti] = Extract_datafromdist(lon,lat,...
            SSHsanom',a,0);
        [lonki2, latki2 ,pathdataSST, disti2] = Extract_datafromdist(lon,...
            lat,SSTsanom',a,0);


        %SST_sHM=mean(SSTsanomM,1,'omitnan')';
        SST_HM(:,iter)=pathdataSST;
        SSH_HM(:,iter)=pathdataSSH;
        SSTanom(:,:,iter)=SSTsanom;
        SSHanom(:,:,iter)=SSHsanom;
        lonianom(:,:,iter)=loni;
        
        

        pcolor(lon',lat',SSHsanom);shading flat;
        colorbar

        cmocean haline
        
        hold on
        %[c,h]=contour(lonissh,latissh,SSHi,[sshK sshK],'k');
        plot(lonki,latki,'r','linestyle','-','linewidth',1.5)
        borders('countries','k')
        
    
        
     
        land = island(lati,loni);
        SSHsanom(land) = NaN;
        
        fig = gcf;
        pause(0.01)
        clf
      

    end
end




[timek,ditixx]=meshgrid(timesWeek,disti);

%%
    
    
figure
P=get(gcf,'position');
P(3)=P(3)*1;
P(4)=P(4)*5;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');
    pcolor(timek,ditixx,SST_HM);
    %cmocean balance;
      mymap = [0 0 1
    0.15 0.15 1
    0.30 0.30 1
    0.45 0.45 1
    0.60 0.60 1
    0.75 0.75 1
    1 0.75 0.75
    1 0.60 0.60
    1 0.45 0.45
    1 0.30 0.30
    1 0.15 0.15
    1 0 0];

  colormap(mymap)
    caxis([-3 3]);
    shading interp
    cb = colorbar('location','southoutside');
    xlabel(cb,'Anomaly [°C]')
      hold on
     [c,h]=contour(timek,ditixx,SSH_HM,[3:3:30],'k');
     clabel(c,h);
    %title(['SST contour SSH Mean from', num2str(a),'to' num2str(b) , 'Degrees' ]);
    
    hold on
    
   %set(gca,'xtick',[150:10:280],'xticklabel',[[150:10:180] [-170:10:-80]],'xlim',[150 280]);

    %ylabel('Distance'); 
    datetick('x','YY/mm');
    xlabel('TIME(YY/mm)');


hold on
 ax = gca;
 set (gca,'yaxislocation','right')
 ax.YTick      = ([ditixx(I1),ditixx(I2),ditixx(I3),ditixx(I4),...
     ditixx(I5),ditixx(I6),ditixx(I7),ditixx(I8),ditixx(I9),...
     ditixx(I10),ditixx(I11),ditixx(I12)]);

 ax.YTickLabel = {'Puerto Pizarro','Paita','San Jose','Chicama',...
     'Huanchaco','Chimbote','Huacho','Callao','Pisco',...
     'Atico','Matarani','Ilo'};
 set(gca,'FontSize',15)
 set (gca,'Ydir','reverse')





 