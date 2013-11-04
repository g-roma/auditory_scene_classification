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

function [ predict_label ] = classify_scenes(tmp_path, train_file,test_file, output_file, grid_search)
    addpath('rastamat/');
    addpath('libsvm/')
    
    classes = {'bus' 'busystreet' 'office' 'openairmarket' 'park' 'quietstreet' 'restaurant' 'supermarket' 'tube' 'tubestation'};
    
    [tr_names,tr_labels] = loadClassificationOutput(train_file);
    [te_names,te_labels] = loadClassificationOutput(test_file);
    
    
    %% extract features
    disp('analyzing training files');
    train_features = analyze_files(tr_names,tmp_path);
    disp('analyzing test files');
    test_features = analyze_files(te_names, tmp_path);
    train_labels = [];
    test_labels = ones(length(te_names),1);
    
    train_labels = get_class_indices(tr_labels);
    
    [train_z, mu, sigma] = zscore(train_features);
    MU = repmat(mu,size(test_features,1),1);
    SIGMA = repmat(sigma,size(test_features,1),1);
    test_z = (test_features -MU)./SIGMA;
    
    
    %% SVM grid Search inspired in http://labrosa.ee.columbia.edu/projects/consumervideo/
    
    if grid_search
        disp('performing grid search');
        tuning_data_fraction = 0.9;
        train_size = round(tuning_data_fraction*size(train_z,1));
        p = randperm(size(train_z,1));
        trainX = train_z(p(1:train_size),:);
        validateX = train_z(p(train_size+1:end),:);
        trainY = get_class_indices(tr_labels(p(1:train_size)));
        validateY = get_class_indices(tr_labels(p(train_size+1:end)));
                
        
        gamma = 2.^[-10:1:10];
        C = 2.^[0:13];
        
        params = zeros(length(gamma),length(C));
        best_a = 0;
        best_g = 0;
        best_C = 0;
     
        for gi= 1:length(gamma)
            for Ci = 1:length(C)
                m = svmtrain(trainY', trainX, sprintf('-c %d -g %2.5f -q',C(Ci),gamma(gi)));
                [p,a] = svmpredict(validateY', validateX, m, '-q');
                if a(1) > best_a
                    best_C = C(Ci);
                    best_g = gamma(gi);
                    best_a = a(1);
                end
            end
        end
        disp('grid search done');
    else
        best_C=70;
        best_g = 0.003;
    end
 
    
    model = svmtrain(train_labels', train_z, sprintf('-c %d -g %2.5f -q',best_C,best_g));
    [predict_indices, accuracy_obj, prob_values] = svmpredict(test_labels, test_z, model,'-q');
    predict_label = classes(predict_indices);
    
    
    outfd = fopen(output_file,'w+');
    
    for i = 1:length(te_names)
         fprintf(outfd,'%s\t',[char(te_names(i))]);
         fprintf(outfd,'%s\n',[char(predict_label(i))]);
    end
    fclose(outfd);    
    
    function idx = get_class_indices(labels)
        idx = [];            
        for i=1:length(labels)
        class =  find(strcmp(classes,labels(i)));
        idx(i) = class;
    end
        
end

    
end

