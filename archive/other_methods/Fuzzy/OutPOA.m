% 提取 POA 数据
POA_data = out.POA;

% 数据长度检查
numDataPoints = length(POA_data);
numMinutesPerDay = 1440; % 每天的分钟数
numDays = numDataPoints / numMinutesPerDay;

if mod(numDataPoints, numMinutesPerDay) ~= 0
    error('数据点数不能被每天的分钟数整除，请检查数据长度。');
end

% 重构数据，将每一天的数据整合为一行
reshaped_POA_data = reshape(POA_data, numMinutesPerDay, numDays)';

% 创建时间向量，每行代表一天
dayNumbers = (1:numDays)';

% 计算每一天的总和 (假设数据是以分钟为单位)
% 将瓦特转换为千瓦特，乘以每分钟（1/60小时），然后计算每天总和
dailySum_POA = sum(reshaped_POA_data / 1000 * (1 / 60), 2);

% 将时间向量、重构的数据和每天的总和合并成一个表格
dataTable_POA = array2table([dayNumbers, reshaped_POA_data, dailySum_POA], ...
    'VariableNames', ['Day', arrayfun(@(x) sprintf('Minute%d', x), 1:numMinutesPerDay, 'UniformOutput', false), 'DailySum_kWh']);

% 导出到CSV文件
writetable(dataTable_POA, 'POA_data_daily.csv');

% 计算年总和
annualSum_POA = sum(dailySum_POA);

fprintf('一年生产的千瓦时数 (POA): %.2f kWh\n', annualSum_POA);
