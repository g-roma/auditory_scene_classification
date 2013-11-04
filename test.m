make_list_files;
classify_scenes('/tmp', 'fold1_train.txt','fold1_test.txt', 'fold1_result.txt', 1)
classify_scenes('/tmp', 'fold2_train.txt','fold2_test.txt', 'fold2_result.txt', 1)
classify_scenes('/tmp', 'fold3_train.txt','fold3_test.txt', 'fold3_result.txt', 1)
classify_scenes('/tmp', 'fold4_train.txt','fold4_test.txt', 'fold4_result.txt', 1)
classify_scenes('/tmp', 'fold5_train.txt','fold5_test.txt', 'fold5_result.txt', 1)
[confusionMat, AccFolds, Acc, Std] = sceneClassificationMetrics_eval(5, 'foldGTlist.txt', 'foldRESlist.txt')
