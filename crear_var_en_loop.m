%crear variables en loop

N=19;
for k=1:length(C)
    my_field = strcat('f_',num2str(C(k)),num2str(k),'_name');
    variable.(my_field) = k*2;
end