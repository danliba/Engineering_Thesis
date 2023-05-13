%%TESIS REGIONES
labels_x={'86ºW','84ºW','82ºW','80ºW','78ºW','76ºW','74ºW','72ºW','70ºW','68ºW'};
labels_y={'20ºS','18ºS','16ºS','14ºS','12ºS','10ºS','8ºS','6ºS','4ºS','2ºS','0ºN'};

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