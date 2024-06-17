% 假设 irradiance 和 dailySum_PO 已经在 workspace 中
% 这里我将光照强度数据也重新整形为每天的数据并计算总量

% 确定光照强度数据点数
numDataPoints = length(irradiance);

% 假设每年有366天（考虑到闰年），每天1440分钟
numDays = 366;
numMinutesPerDay = 24 * 60;
totalExpectedDataPoints = numDays * numMinutesPerDay;

% 如果光照强度数据点数多于预期，则删除多余的数据点
if numDataPoints > totalExpectedDataPoints
    irradiance = irradiance(1:totalExpectedDataPoints);
    numDataPoints = length(irradiance); % 更新数据点数
elseif numDataPoints < totalExpectedDataPoints
    error('光照强度数据点数不足366天的预期总数');
end

% 重构数据，将每一天的数据整合为一行
reshaped_irradiance = reshape(irradiance, numMinutesPerDay, numDays)';

% 计算每一天的光照总量
% 光照强度单位假设为W/m^2，转换为kW然后计算kWh
dailySum_irradiance = sum(reshaped_irradiance / 1000 * (1 / 60), 2);

% 创建时间向量，每行代表一天
dayNumbers = (1:numDays)';

% 仅导出光照总量数据
irradiance_data_export = array2table([dayNumbers, dailySum_irradiance], ...
    'VariableNames', {'Day', 'DailySum_irradiance_kWh'});

% 导出到CSV文件
writetable(irradiance_data_export, 'irradiance_data_daily.csv');

% 计算效率
if length(dailySum_POA) == length(dailySum_irradiance)
    efficiency = dailySum_POA ./ dailySum_irradiance;
else
    error('dailySum_PO and dailySum_irradiance arrays are of different lengths');
end

% 创建效率表格并导出到CSV文件
dataTable_efficiency = array2table([dayNumbers, efficiency], 'VariableNames', {'Day', 'Efficiency'});
writetable(dataTable_efficiency, 'efficiency_data.csv');

% 打印年总效率
annualEfficiency = sum(dailySum_POA) / sum(dailySum_irradiance);
fprintf('一年生产的总效率: %.2f%%\n', annualEfficiency * 100);
