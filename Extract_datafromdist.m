

function [lonki, latki ,pathdata, disti] = Extract_datafromdist(longo,lato,data,mn,range)


[Lon,Lat] = meshgrid(longo,lato);
disti=0:5000:2.6e6;

[lonk, latk]=Extract_distaxis(Lon, Lat,mn,range);


dx=distance(latk(2:end),lonk(2:end),latk(1:end-1),lonk(1:end-1)).*60.*1852;
distx=cat(2,0,cumsum(dx));

lonki=interp1(distx,lonk,disti);
latki=interp1(distx,latk,disti);

pathdata=interp2(longo, lato,data',lonki,latki);

end
        