rm(list = ls())
source("sensWeighted.R")
data <- read.csv('generated_sens_spec.csv')
data_y <- read.csv('test_results.csv')
test_methods <- c('Jsens', 'Jsens2', 'Csens', 'Csens2', 'CPsens')
result_frame <- data.frame(
X = test_methods,
sens = 1:length(test_methods),
spec = 1:length(test_methods)
)


result_frame[result_frame$X=='Jsens', c('sens', 'spec')] <- Jsens(data$sens, data$spec)[1:2]
result_frame[result_frame$X=='Jsens2', c('sens', 'spec')] <- Jsens2(data$sens, data$spec)[1:2]
result_frame[result_frame$X=='Csens', c('sens', 'spec')] <- Csens(data$sens, data$spec)[1:2]
result_frame[result_frame$X=='Csens2', c('sens', 'spec')] <- Csens2(data$sens, data$spec)[1:2]
result_frame[result_frame$X=='CPsens', c('sens', 'spec')] <- CPsens(data$sens, data$spec)[1:2]

temp <- merge(data_y, result_frame, by='X')
print('Sens test: ')
abs(temp$sens.x - temp$sens.y) <= 1e-12
print('Spec test: ')
abs(temp$spec.x - temp$spec.y) <= 1e-12



