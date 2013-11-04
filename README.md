The files in this folder represent our submission for the Scene Classificatoin task of the IEEE D-CASE AASP Challenge (http://c4dm.eecs.qmul.ac.uk/sceneseventschallenge/)

The code has been tested mainly on Matlab2012 on OSX
Required libraries: rastamat and libsvm

The implemented approach is described in:
G. Roma, W. Nogueira, P.Herrera, _Recurrence Quantification Analysis Features for Environmental Sound Recognition_. Proceedings of IEEE Workshop on Applications of Signal Processing to Audio and Acoustics. New Paltz, USA 2013.

The main files are:

* classify_scenes.m
* analyze_files.m
* RQA.m

The rest of matlab files can be used to test the code. Some of the files are taken from: https://soundsoftware.ac.uk/projects/aasp-d-case-metrics

Two submissions were sent to the challenge, one uses hardcoded SVM parameters, the other does grid search:

classify_scenes(tmp_path, train_file,test_file, output_file, 0) % use hardcoded parameters for SVM  
classify_scenes(tmp_path, train_file,test_file, output_file, 1) % use grid search 

The temp_path is used to store features.

