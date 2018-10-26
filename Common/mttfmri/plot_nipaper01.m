% Show efficiency and power tradeoffs
%
% Files are created by batch01.m and make_mixed.m and plot_nipaper01_ent
%
%
% modifications
% 030514 - subsample the permuted blocks to reduce the number of 
%          points plotted, also just plot the best random point.
%        - changed to colored lines for NIMG paper.
%        - add plotting of entropies for NIMG paper, uses MAT file generated
%          in plot_nipaper01_ent.m
%
%


load nipaper_01_ent; % generated by plot_nipaper_01_ent.m
randomspan = 1;
blockspan = [1:100 110:10:200];
if ~exist('docolor') docolor = 0;end
if docolor;
  colordef none;
else
  colordef white
end
filenames = ['ne2l0123no80z0ds2c0v3cn0ba0';
	     'ne3l0123no60z0ds2c0v3cn0ba0';
     	     'ne4l0123no48z0ds2c0v3cn0ba0';
       	     'ne5l0123no40z0ds2c0v3cn0ba0';];


fontsize = 12;
titlstrs = str2mat('(a) Q = 2','(b) Q = 3','(c) Q = 4','(d) Q = 5');

nf = size(filenames,1);
ind= 1;dind = 1;itype = 1;
nr = 2;nc = 2;
figure(1);clf;
for nfile = 1:nf;




  filename = deblank(filenames(nfile,:));
  
eval(sprintf('load %s',filename));

nevents = str2num(filename(3))
Q = nevents;
% UPPER BOUNDS
atrace = approxtrace(nummods,numones,npts);
atrace = atrace/((1-numones/npts)*numones*nummods);
tmaxeff = npts/(2*(Q+1)*nummods);

tmaxdet = npts*nummods/(2*(Q+1));
neffmat = effmat/tmaxeff;
ndetmat = detmat/tmaxdet;
nreffmat = reffmat/tmaxeff;
nrdetmat = rdetmat/tmaxdet;
nmeffmat = meffmat/tmaxeff;
nmdetmat = mdetmat/tmaxdet;

% THEORETICAL CURVES
k = nummods;
i0 = 1.0;
alpha =[1/k 0.1:0.05:1.0];
thetavec = [45  55 65  80 90]/180*pi;
teff = alpha.*(1-alpha) ./(1+alpha*(k^2-2*k))*i0*nummods*npts/(2*(Q+1));
alphamat = alpha(:)*ones(1,length(thetavec));
teffmat = teff(:)*ones(1,length(thetavec));
xrangemat = ones(length(alpha),1)*thetavec(:)';

tdet =i0*nummods*((1-alphamat).*(sin(xrangemat).^2)/(k-1)+alphamat.* ...
	  cos(xrangemat).^2);
tdet = tdet*npts/(2*(Q+1));
ntdet = tdet/tmaxdet;
nteffmat = teffmat/tmaxeff;


if docolor;
ltype = ['m+';
	 'm+';
	 'm+';
	 'm+';
	 'm+';
	 'm+';
	 'yd';
	 'yo';];  
acolor = 'g';facecolor = 'y';
else
ltype = ['k+';
	 'k+';
	 'k+';
	 'k+';
	 'k+';
	 'k+';
	 'kd';
	 'ko';];
acolor = 'k';facecolor = 'k';

ltype = ['c+';
	 'r+';
	 'b+';
	 'g+';
	 'y+';
	 'm+';
	 'rp';
	 'ko';];



end



  for iorder = 1;
    
    
        % PICK BEST 10 RANDOM DESIGNS
	[s,s_ind] = sort(squeeze(nreffmat(itype,iorder,dind,:,1)));
	s_ind = flipud(s_ind(:));
	figure(1)
	subplot(nr,nc,ind);
	hp = plot(squeeze(ndetmat(itype,iorder,dind,blockspan,1)),squeeze(neffmat(itype,iorder,dind,blockspan,1)),ltype(1,:),...
	     squeeze(ndetmat(itype,iorder,dind,blockspan,2)),squeeze(neffmat(itype,iorder,dind,blockspan,2)),ltype(2,:),...
	     squeeze(ndetmat(itype,iorder,dind,blockspan,3)),squeeze(neffmat(itype,iorder,dind,blockspan,3)),ltype(3,:),...	     
	     squeeze(ndetmat(itype,iorder,dind,blockspan,4)),squeeze(neffmat(itype,iorder,dind,blockspan,4)),ltype(4,:),...	     
	     squeeze(ndetmat(itype,iorder,dind,blockspan,5)),squeeze(neffmat(itype, ...
						  iorder,dind,blockspan,5)),ltype(5,:),...
	     squeeze(ndetmat(itype,iorder,dind,blockspan,6)),squeeze(neffmat(itype, ...
						  iorder,dind,blockspan,6)),ltype(6,:),...
	     squeeze(nrdetmat(itype,iorder,dind,s_ind(randomspan),1)),squeeze(nreffmat(itype, ...
						  iorder,dind, ...
						  s_ind(randomspan),1)),ltype(7,:));
	
	set(hp(7),'MarkerSize',9,'MarkerFaceColor','r');
	axis([0 0.65 0 1.1]);
	hold on;
	if(nevents < 5)
	     hm = plot(squeeze(nmdetmat(itype,iorder,dind,1,1)),squeeze(nmeffmat(itype, ...
						  iorder,dind,1,1)),ltype(8,:)); ...

		  set(hm,'MarkerFaceColor',facecolor);
	end
	if (nevents < 5)
	  eval(sprintf('load mixed_ne%dnp240',nevents)); % file from make_mixed.m
	  mspan = 3:size(ndetmix,1);
	  hmixed = plot(ndetmix(mspan,1),neffmix(mspan,1),'gx');
	end


	
	if docolor
	  plot(ntdet,nteffmat,'w-'); %theoretical curves
	else
	  plot(ntdet,nteffmat,'k-'); %theoretical curves
	end
	hold off;
        switch ind
	  case 1
	  hleg = legend([hp;hm;hmixed],'1-block','2-block','4-block','8-block','16-block','40-block','random','m-seq','mixed',1);
	 case 2
	  hleg = legend([hp;hm;hmixed],'1-block','2-block','4-block','10-block','15-block','30-block','random','m-seq','mixed',1);
	 case 3
	  hleg = legend([hp;hm;hmixed],'1-block','2-block','4-block','8-block','12-block','24-block','random','m-seq','mixed',1);
	 case 4
	  hleg = legend(hp,'1-block','2-block','4-block','8-block','10-block','20-block','random',1);
	end
	set(hleg,'Visible','off');set(allchild(hleg),'visible','on');
%        set(hleg,'FontSize',2);
	grid;
	set(gca,'FontSize',fontsize);
	ylabel('Normalized \xi_{tot}')
	xlabel('Normalized R_{tot}')
	title(deblank(titlstrs(ind,:)));
	if 0
	if(ind == 3)
	  arrow([0.2,1],[0.08,.96],'Color',acolor);

%	  arrow([0.25,0.85],[0.14,0.83]);
      
	  arrow([0.3,.7],[0.08,0.8],'Color',acolor);
	  arrow([0.4,0.5],[0.3,0.35],'Color',acolor);
	  h1 = text(0.21,1.0,'m-sequence');set(h1,'FontSize',fontsize);
	  	  h1b = text(0.21,.93,'based');set(h1b,'FontSize',fontsize);
	  h3 = text(0.31,0.70,'randomly');set(h3,'FontSize', ...
							   fontsize);
	  h3b = text(0.31,0.63,'generated');set(h3b,'FontSize',fontsize);
	  h4 = text(0.41,0.5,'permuted');set(h4,'FontSize', ...
						      fontsize);
		  h4b = text(0.41,0.43,'block');set(h4b,'FontSize',fontsize);
	elseif (ind == 1);  
  	  arrow([0.2,1],[0.08,.98],'Color',acolor);

%	  arrow([0.25,0.85],[0.14,0.83]);
      
	  arrow([0.3,.7],[0.08,0.93],'Color',acolor);
	  arrow([0.4,0.5],[0.3,0.35],'Color',acolor);
	  h1 = text(0.21,1.0,'m-sequence');set(h1,'FontSize',fontsize);
	  	  h1b = text(0.21,.93,'based');set(h1b,'FontSize',fontsize);
	  h3 = text(0.31,0.70,'randomly');set(h3,'FontSize', ...
							   fontsize);
	  h3b = text(0.31,0.63,'generated');set(h3b,'FontSize',fontsize);
	  h4 = text(0.41,0.5,'permuted');set(h4,'FontSize', ...
						      fontsize);
		  h4b = text(0.41,0.43,'block');set(h4b,'FontSize', ...
							fontsize);
        elseif (ind == 2)		 
    	  arrow([0.2,1],[0.08,.96],'Color',acolor);

%	  arrow([0.25,0.85],[0.14,0.83]);
      
	  arrow([0.3,.7],[0.08,0.88],'Color',acolor);
	  arrow([0.4,0.5],[0.3,0.35],'Color',acolor);
	  h1 = text(0.21,1.0,'m-sequence');set(h1,'FontSize',fontsize);
	  	  h1b = text(0.21,.93,'based');set(h1b,'FontSize',fontsize);
	  h3 = text(0.31,0.70,'randomly');set(h3,'FontSize', ...
							   fontsize);
	  h3b = text(0.31,0.63,'generated');set(h3b,'FontSize',fontsize);
	  h4 = text(0.41,0.5,'permuted');set(h4,'FontSize', ...
						      fontsize);
		  h4b = text(0.41,0.43,'block');set(h4b,'FontSize', ...
							fontsize);
	elseif (ind == 4)		 
	  arrow([0.3,.7],[0.08,0.75],'Color',acolor);
	  arrow([0.4,0.5],[0.3,0.35],'Color',acolor);
	  h3 = text(0.31,0.70,'randomly');set(h3,'FontSize', ...
							   fontsize);
	  h3b = text(0.31,0.63,'generated');set(h3b,'FontSize',fontsize);
	  h4 = text(0.41,0.5,'permuted');set(h4,'FontSize', ...
						      fontsize);
		  h4b = text(0.41,0.43,'block');set(h4b,'FontSize', ...
							fontsize);
	end
       end

  end
  

  if ind < 4
    figure(2);
    eval(sprintf('evec = evec_%d;',nfile));
    eval(sprintf('revec = revec_%d;',nfile));
    eval(sprintf('mevec = mevec_%d;',nfile));
    for entorder = 2:3
      pind = ind+3*(entorder-2);
      subplot(2,3,pind);
      bspan = 2;
      hoffset = 0;
      hent = plot(squeeze(neffmat(itype,iorder,dind,blockspan,bspan)),squeeze(2.^evec(blockspan,bspan,entorder)-hoffset),'k+',...
       squeeze(nreffmat(itype,iorder,dind,s_ind(1),1)),2.^revec(1,entorder)-hoffset,'kp',...
       squeeze(nmeffmat(itype,iorder,dind,1,1)),2.^mevec(1, ...
						  entorder)-hoffset,'ko');
      
      set(hent(3),'MarkerFaceColor','k');
      set(hent(2),'MarkerSize',11,'MarkerFaceColor','k');
      hold on;
      if 0
      if(nevents < 5);
	plot(neffmix(:,1),2.^squeeze(entmix(:,1,entorder)),'x')
      end	
      end
      plot([0 1],[nevents+1 nevents+1],'k--');hold off;grid;
      set(gca,'FontSize',fontsize);
      xlabel('Normalized \xi_{tot}');
      if pind < 4
	ylabel('2\^{H_2}');
      else
	ylabel('2\^{H_3}')
      end
      set(gca,'Xlim',[0 1]);
      set(gca,'Ylim',[1 nevents+1.2]);
      switch pind
       case 1
	title('(a) Q = 2, 2nd order entropy');

       case 2
	title('(b) Q = 3, 2nd order entropy');

       case 3
	title('(c) Q = 4, 2nd order entropy');

       case 4
	title('(a) Q = 2, 3rd order entropy');

       case 5
	title('(b) Q = 3, 3rd order entropy');

       case 6
	title('(c) Q = 4, 3rd order entropy');

      end
      
      if pind == 6;
	hleg = legend('2-block','random','m-sequence',1);
%	set(hleg,'Visible','off');set(allchild(hleg),'visible','on');
      end
      
    end
  
  end

ind = ind + 1;

end

if ~exist('doprint');doprint = 0;end
if doprint
if docolor
  set(gcf,'InvertHardCopy','off');
  print -dtiff nimg01.tiff
else
  print -depsc nimg01.epsc
end
end

if doprint
figure(1);

print -dtiff NIMG770_fig1.tif
print -depsc NIMG770_fig1.eps
figure(2);
print -dtiff NIMG770_fig2.tif
print -deps NIMG770_fig2.eps
end