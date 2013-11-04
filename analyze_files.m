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

function [ features ] = analyze_files( input_files, tmp_path )
    use_stored_features = 1;
    
    features = [];
    for i=1:length(input_files)
        disp(strcat('analyzing',input_files(i)));
        features = [features; analyze(input_files(i))];
    end        

    function ftrs = analyze(in_file) 
       w = 40; 
       h = 20;
       r = 0.03; 
       dl = 2; 
       vl = 2; 
       [pathstr, name, ext] = fileparts(char(in_file));
       tmp_fname = strcat(tmp_path,'/',name,'.mat');
       if use_stored_features && (exist(tmp_fname)==2)
            load(tmp_fname);
       else
           [x,fs] = wavread(char(in_file));
           x = x(:,1);
           mfcc = melfcc(x,fs,'minfreq',0,'maxfreq',900,'dither',1)';
           N = max(size(mfcc));
           steps = round(N/h);
           wrqa = [];
           for i = 0:steps-1
                init = (i*h)+1;
                final = min((i*h)+w,N);
                ftr = mfcc(init:final,:);      
                d = squareform(pdist(ftr,'cosine'));
                D = d<r;
                rqa = RQA(D,dl,vl);
                wrqa = [wrqa;rqa];
           end

            ftrs = [mean(mfcc,1),std(mfcc,1),mean(wrqa,1)];
            ftrs(isnan(ftrs))=0;
            ftrs(isinf(ftrs))=0;
            save(tmp_fname,'ftrs');
       end
    end
end

