
function [SHHw,Tempw,ycat,wcat] = daily_to_weekly(data,yrstart,yrend)



disp('Converting dayly to weekly')
% obtain time lon and lat
time=ncread(data,'time')./24;
lonsact=ncread(data,'longitude');
latsact=ncread(data,'latitude');



% convert single variables, time lon lat to double
time=double(time);
lon=double(lonsact);
lat=double(latsact);

% convert julian date of SSH to MATLAB julian date
time=time+datenum(1950,1,1,0,0,0);
% get time vector with year, month, date, hour, minite, second
[yr,mo,da,hr,mi,se]=datevec(time);

if nargin == 2


yrt = find(yr == yrstart);
yrt1 = yrt(1);
yrt2 = yr(yrt1:end);

t= datetime(yrstart,01,01):datetime(yr(end),mo(end),da(end));
w = week(t);

WSSH=w;
WSSH=WSSH';

yrst=yrstart;
yren=yr(end);
west=1;
ween=WSSH(end);
ween0=ween;
end

if nargin == 3 
yrt = find(yr == yrstart);
yrt1 = yrt(1);
  if yrend == yrstart
  yrt3=length(find(yr == yrstart));
  yrt2 = yr(yrt1:yrt3);
  
  else
  yrt3=length(find(yr == yrend));
  yrt2 = yr(yrt1:yrt3);  
  end

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

end




for gg=yrst:yren
    if gg==yren
        ween=ween0;
    else % otherwise, moen is 12
        ween=53;
    end  
ff=repmat(gg,ween,1);
 if gg==yrst
    Range01=ff;             
 end
 if gg > yrst 
Range01=cat(1,Range01,ff);
 end
end

%Loop save weeks
for ii=yrst:yren
    if ii==yren
        ween=ween0;
    else % otherwise, moen is 12
        ween=53;
    end     
    
   zz=(west:ween)'; 
 if ii==yrst
    Range02=(west:ween)';             
 end
 if ii > yrst 
Range02=cat(1,Range02,zz);
 end
end

% initialize iter to zero
iter=0;
% loop for year
for iy=yrst:1:yren
    % in case iy is greater then let most is 1. 
    if iy>=yrst
        west=1;
    end
    % in case iy is the last year then  then let moen to be kept value, moen0,
    if iy==yren
        ween=ween0;
    else % otherwise, moen is 12
        ween=53;
    end
    
    % loop for month
    for iw=west:1:ween
        % increase iter by 1
        iter=iter+1;
        disp(['Year: ' num2str(iy) ' WeeK: ' num2str(iw)])
        
        % extract indice which yr and mo satisfy the 
        % specified year and month by iy and im 
        indx=find(yrt2==iy & WSSH==iw);
        

        % count the number of indice
        numrec=length(indx);
        
        % loop for indice for year and month of yr and mo.
        for irec=1:1:numrec
            % get SSH data

            ZOS=ncread(data,'zos',[1 1 indx(irec)],...
                [length(lon) length(lat) 1],[1 1 1]);
            TTS=ncread(data,'thetao',[1 1 1 indx(irec)],...
                [length(lon) length(lat) 1 1],[1 1 1 1]);
            % transpose the data
            ZOS=ZOS';
            TTS=TTS';
            % if this is the first time for the loop generate adtm with the 
            % same size as adti filled with all zero  
            if irec==1
                ZOSpm=zeros(size(ZOS));
                TTSpm=zeros(size(TTS));
            end
            % summing adti devided by the number of data to adtm, which
            % enables to get monthly average of adti
    
            
            ZOSpm=ZOSpm+ZOS./numrec;
            TTSpm=TTSpm+TTS./numrec;
                
            
        end
        % store the adtm in SSHs with an index of iter in the third dimension
        SHHWeek(:,:,iter)=ZOSpm;
        TempWeek(:,:,iter)=TTSpm;
        
        
        % store the julian date into times
        times(iter,1)=datenum(iy,iw,15,0,0,0);

    end
end
SHHw=SHHWeek;
Tempw=TempWeek;
ycat=Range01;
wcat=Range02;
