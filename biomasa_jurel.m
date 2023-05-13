[data,jj,raw]=xlsread('biomasa_acustica.xlsx','biomasa jurel','A1:E37');

plot(data(:,1),data(:,5),'d--');
xlim([1983 2018]);
grid minor