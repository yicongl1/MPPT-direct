% 用户选择日期
selected_date_str = inputdlg('Inserer une date（Format：yyyy-MM-dd）：', '选择日期', [1, 20]);
selected_date_str = selected_date_str{1}; % 将用户输入的日期转换为字符串

% 查找选择的日期在数据中的索引
date_index = find(strcmp(date_str, selected_date_str));

% 检查是否找到了日期
if isempty(date_index)
    error('Date invalide：%s', selected_date_str);
end

% 提取选择日期的时间范围
start_index = (date_index - 1) * num_times + 1;
end_index = date_index * num_times;

% 提取选择日期范围内的样本
j_temperature = getsamples(ts_temperature, start_index:end_index);
j_irradiance = getsamples(ts_irradiance, start_index:end_index);

% 将时间轴重新调整为从0开始
j_temperature.Time = j_temperature.Time - j_temperature.Time(1);
j_irradiance.Time = j_irradiance.Time - j_irradiance.Time(1);

% 保存数据到工作区
assignin('base', 'j_temperature', j_temperature);
assignin('base', 'j_irradiance', j_irradiance);