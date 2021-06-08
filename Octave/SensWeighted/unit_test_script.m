% This unit test script simply runs all the methods for the values in
% generated_sens_spec.csv and compares the sens and spec values obtained
% with the ones in test_results.csv
% If everything works, prints out 5x2 matrix.
% The matrix is a 5x2 matrix of 1s if all methods are working as intended.

clear all;
test_file_path = [cd '\generated_sens_spec.csv'];
result_file_path = [cd '\test_results.csv'];

X_unit_test = csvread(test_file_path)(2:end, :);
Y_unit_test = csvread(result_file_path)(2:end, 2:end);
unit_sens = X_unit_test(:, 2);
unit_spec = X_unit_test(:, 3);

results = [];
[se, sp, t] = SenConp(unit_sens, unit_spec, X_unit_test(:, 1));
results = [results; [se, sp, t]];
[se, sp, t] = SenCirc(unit_sens, unit_spec, X_unit_test(:, 1));
results = [results; [se, sp, t]];
[se, sp, t] = SenEll(unit_sens, unit_spec, X_unit_test(:, 1));
results = [results; [se, sp, t]];
[se, sp, t] = SenJ(unit_sens, unit_spec, X_unit_test(:, 1));
results = [results; [se, sp, t]];
[se, sp, t] = SenLin(unit_sens, unit_spec, X_unit_test(:, 1));
results = [results; [se, sp, t]](:, 1:2);

abs(results - Y_unit_test) <= 1e-12