rm(list = ls())
source("sensWeighted.R")
data <- read.csv('generated_sens_spec.csv')
data_y <- read.csv('test_results.csv')
test_methods <- c('SenJ', 'SenLin', 'SenCirc', 'SenEll', 'SenConp')
result_frame <- data.frame(
X = test_methods,
sens = 1:length(test_methods),
spec = 1:length(test_methods)
)


result_frame[result_frame$X=='SenJ', c('sens', 'spec')] <- SenJ(data$sens, data$spec)[1:2]
result_frame[result_frame$X=='SenLin', c('sens', 'spec')] <- SenLin(data$sens, data$spec)[1:2]
result_frame[result_frame$X=='SenCirc', c('sens', 'spec')] <- SenCirc(data$sens, data$spec)[1:2]
result_frame[result_frame$X=='SenEll', c('sens', 'spec')] <- SenEll(data$sens, data$spec)[1:2]
result_frame[result_frame$X=='SenConp', c('sens', 'spec')] <- SenConp(data$sens, data$spec)[1:2]

temp <- merge(data_y, result_frame, by='X')
print('Sens test: ')
abs(temp$sens.x - temp$sens.y) <= 1e-12
print('Spec test: ')
abs(temp$spec.x - temp$spec.y) <= 1e-12



