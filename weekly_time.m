
function [timesWeek,timesk] = weekly_time(yrst,yren,ween)

disp('Getting weeks')

ween0=ween;
ll=0;
for yk=yrst:1:yren

    if yk>=yrst
        west=1;
    end
    % in case iy is the last year then  then let moen to be kept value, moen0,
    if yk==yren
        ween=ween0;
    else % otherwise, moen is 12
        ween=53;
    end
    for wk=west:1:ween
        ll=ll+1;
        disp(['Year: ' num2str(yk) ' WeeK: ' num2str(wk)])
    date_w=week_to_date(yk,1,1,wk);
    
    timesk(ll,1)=date_w;
    end
end
timesw=timesk;
timesWeek=datenum(timesk);