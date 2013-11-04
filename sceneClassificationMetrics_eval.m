% from https://soundsoftware.ac.uk/projects/aasp-d-case-metrics

function [confusionMat, AccFolds, Acc, Std] = sceneClassificationMetrics_eval(numfolds, foldsGTlist, foldstestlist)

% Function takes as input a number of folds (numfolds), a text file
% containing a list of filenames with the ground truth per fold (foldsGTlist), 
% and a text file containing a list of filenames with the classification
% output (foldstestlist)
%
% e.g. [confusionMat, AccFolds, Acc, Std] = sceneClassificationMetrics_eval(5, 'foldGTlist.txt', 'foldtestlist.txt');


% Initialize
classList = {'bus','busystreet','office','openairmarket','park','quietstreet','restaurant','supermarket','tube','tubestation'};
confusionMat = zeros(10,10);
AccFolds = zeros(1,numfolds);


% For each fold
fid1 = fopen(foldsGTlist,'r+');
fid2 = fopen(foldstestlist,'r+');
for i=1:numfolds
    
    % Load classification output and ground truth
    tline1 = fgetl(fid1);
    [fileIDGT,classIDGT] = loadClassificationOutput(tline1);
    tline2 = fgetl(fid2);
    [fileID,classID] = loadClassificationOutput(tline2);
    
    % Compute confusion matrix per fold
    confusionMatTemp = zeros(10,10);
    for j=1:length(classIDGT)
        pos = strmatch(fileIDGT{j}, fileID, 'exact');
        posClassGT = strmatch(classIDGT{j}, classList, 'exact');
        posClass = strmatch(classID{pos}, classList, 'exact');
        confusionMatTemp(posClassGT,posClass) = confusionMatTemp(posClassGT,posClass) + 1;
    end
    
    % Compute accuracy per fold
    AccFolds(i) = sum(diag(confusionMatTemp))/sum(sum(confusionMatTemp));
    confusionMat = confusionMat + confusionMatTemp;
    
end
fclose(fid1);
fclose(fid2);


% Compute global accuracy and std
Acc = mean(AccFolds);
Std = std(AccFolds);
