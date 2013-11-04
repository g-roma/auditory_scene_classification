% Copyright 2013 MUSIC TECHNOLOGY GROUP, UNIVERSITAT POMPEU FABRA
%
% Written by Gerard Roma <gerard.roma@upf.edu>
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU Affero General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Affero General Public License for more details.
%
% You should have received a copy of the GNU Affero General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function [ftr] = RQA(D, lmin,vmin)
  N = max(size(D));
  pts =  sum(D(:));

  det = 0;
  diags=[];
  for i = 1:N-1     
      line = [0;diag(D,i);0];
      starts=find(diff(line)==1); % line starts
      ends=find(diff(line)==-1); % line ends
      diags = [diags; ends-starts];
  end

  verts = [];
  intervals = [];
  for i = 1:N   
      line = [0;D(:,i);0];
      starts=find(diff(line)==1); % line starts
      ends=find(diff(line)==-1); % line ends
      verts = [verts;ends-starts];          
  end

  rr = pts/N^2; % recurrence rate
  det = sum(diags(diags>=lmin))/pts; % determinism
  adll = mean(diags(diags>=lmin)); % average diagonal line length
  sddll = std(diags(diags>=lmin)); % standard deviation
  
  dratio = N^2 * sum(diags(diags>=lmin))/(pts^2);
 
  lam = sum(verts(verts>=vmin))/pts; % laminarity
  tt = mean(verts(verts>=vmin)); % trappnig time
  sdvll = std(verts(verts>=lmin)); % standard deviation
  if(isnan(tt))
      tt = 0;
  end
  
  vratio = N^2 * sum(verts(verts>=vmin))/(pts^2); % ratio
 
  lmax = max(1,max(diags)); % maximum diagonal line length
  vmax = max(1,max(verts)); % maximum vertical line length
  
  if(isempty(lmax))
      lmax = 1;
  end
  
  
  if(isempty(vmax))
      vmax = 1;
  end
  
  ddiv = 1/lmax; % divergence
  vdiv = 1/vmax;
 
  diagsH = hist(diags,max(diags));
  diagsH = diagsH/sum(diagsH);
  z = find(diagsH==0);
  temp = diagsH.*log(diagsH);
  temp(z)=0; % remove NaNs from zero prob
  dentropy = sum(temp); % shannon entropy (diagonal)
 
 
  vertsH = hist(verts,max(verts));
  vertsH = vertsH/sum(vertsH);
  z = find(vertsH==0);
  temp = vertsH.*log(vertsH);
  temp(z)=0; % remove NaNs from zero prob
  ventropy = sum(temp); % shannon entropy (vertical)
 
  ftr = [rr,det,adll,lam,tt,dratio,ddiv,dentropy,vratio,ventropy,vdiv];
  end
