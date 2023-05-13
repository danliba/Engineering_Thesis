%%TESIS REGIONES
labels_x={'86�W','84�W','82�W','80�W','78�W','76�W','74�W','72�W','70�W','68�W'};
labels_y={'20�S','18�S','16�S','14�S','12�S','10�S','8�S','6�S','4�S','2�S','0�N'};

figure
P=get(gcf,'position');
P(3)=P(3)*1.5;
P(4)=P(4)*2;
set(gcf,'position',P);
set(gcf,'PaperPositionMode','auto');

[c,d]=shaperead(depfns);
        for j=1:1:size(c,1)
            plot(c(j).X,c(j).Y,'k');
            hold on
        end

        ylim([-20 0]);
         hold on
         [c,d]=shaperead(depfns);
         for j=1:1:size(c,1)
            plot(c(j).X,c(j).Y,'k');
            hold on
         end
        hold on
        text(lonpuertosi,latpuertosi,puertoselect,'fontsize',8,'fontweight','bold');
        ax = gca;
        set(gca,'ytick',[-20:2:0],'yticklabel',labels_y,'ylim',[-20 0]);
        set(gca,'xtick',[-86:2:-68],'xticklabel',labels_x,'xlim',[-86 -68]);
grid minor