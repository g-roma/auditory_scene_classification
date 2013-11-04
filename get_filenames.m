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

function [x,y]  = get_filenames(dir)
    classes = {'bus' 'busystreet' 'office' 'openairmarket' 'park' 'quietstreet' 'restaurant' 'supermarket' 'tube' 'tubestation'};
    
    
    names = [];
    labels = [];

    for i=1:length(classes)
        for j = 1:10
             suffix=sprintf('%02d.wav',j);
             name = strcat(dir,classes(i),suffix);
             names = [names;name];
             labels = [labels; i];
        end
    end
    x = names;
    y = labels;
end

    
