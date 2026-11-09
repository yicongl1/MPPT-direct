% 读取PO和POA数据
PO_data = readtable('PO_data_daily.csv');
POA_data = readtable('POA_data_daily.csv');

% 提取每日总和数据
dailySum_PO = PO_data.DailySum_kWh;
dailySum_POA = POA_data.DailySum_kWh;

% 创建时间向量
numDays = size(PO_data, 1);
days = 1:numDays;

% 绘制图形
figure;
hold on;
plot(days, dailySum_PO, '-o', 'DisplayName', 'PO Daily Sum kWh');
plot(days, dailySum_POA, '-x', 'DisplayName', 'POA Daily Sum kWh');
hold off;

% 添加图例
legend;

% 添加标题和标签
title('Daily Sum of PO and POA over One Year');
xlabel('Day');
ylabel('Daily Sum (kWh)');

% 显示网格
grid on;

% 保存图形
saveas(gcf, 'DailySum_PO_POA.png');
