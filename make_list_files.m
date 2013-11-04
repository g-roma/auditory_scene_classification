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

function make_list_files
    NUM_FOLDS = 5;
    classes = {'bus' 'busystreet' 'office' 'openairmarket' 'park' 'quietstreet' 'restaurant' 'supermarket' 'tube' 'tubestation'};
    [names,labels] = get_filenames('path_to_files');
    cp = cvpartition(labels,'k',NUM_FOLDS);
    for i = 1:NUM_FOLDS
        tr_fnames = names(cp.training(i));
        tr_classes = labels(cp.training(i));
        te_fnames =  names(cp.test(i));
        te_classes =  labels(cp.test(i));
        train_filename = strcat('fold',num2str(i),'_train.txt');
        train_fid = fopen(train_filename,'w+');
        for j = 1:length(tr_fnames)
            fprintf(train_fid,'%s\t',char(tr_fnames(j)));
            fprintf(train_fid,'%s\n',char(classes(tr_classes(j))));
        end
        fclose(train_fid);
        
        test_filename = strcat('fold',num2str(i),'_test.txt');
        test_fid = fopen(test_filename,'w+');
        gt_filename = strcat('fold',num2str(i),'_gt.txt');
        gt_fid = fopen(gt_filename,'w+');
        for j = 1:length(te_fnames)
            fprintf(test_fid,'%s\n',[char(te_fnames(j))]);
            fprintf(gt_fid,'%s\t',[char(te_fnames(j))]);
            fprintf(gt_fid,'%s\n',[char(classes(te_classes(j)))]);
        end
        fclose(gt_fid);
        fclose(test_fid);
        
    end