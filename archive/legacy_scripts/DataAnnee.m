close all
clear
clc

% 导入温度数据
temperature_data = readtable('CellT.xlsx');

% 导入光照强度数据
irradiance_data = readtable('Irradiation.xlsx');

% 获取日期列
date_str = cellstr(temperature_data{2:end, 1}); % 从第二行开始获取日期

% 初始化日期和时间字符串数组
num_dates = size(temperature_data, 1) - 1; % 减去时间行
num_times = 24 * 60;
full_datetime_str = cell(num_dates * num_times, 1);

% 生成日期和时间字符串
for i = 1:num_dates
    for hour = 0:23
        for minute = 0:59
            index = (i - 1) * num_times + (hour * 60) + minute + 1;
            full_datetime_str{index} = [date_str{i} ' ' sprintf('%02d:%02d', hour, minute)];
        end
    end
end

% 将日期时间字符串中的横杠改成斜杠
full_datetime_str = strrep(full_datetime_str, '-', '/');

% 转换为 datetime 对象
time_combined = datetime(full_datetime_str, 'InputFormat', 'yyyy/MM/dd HH:mm');

% 转换为时间秒
time_seconds = seconds(time_combined - time_combined(1));

% 提取温度和光照强度数据列
temperature = table2array(temperature_data(2:end, 2:end)); % 从第二行开始提取温度数据
irradiance = table2array(irradiance_data(2:end, 2:end)); % 从第二行开始提取光照强度数据

% 将二维数组展平
temperature = temperature(:);
irradiance = irradiance(:);

% 创建 timeseries 对象
ts_temperature = timeseries(temperature, time_seconds);
ts_irradiance = timeseries(irradiance, time_seconds);


