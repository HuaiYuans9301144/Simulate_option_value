# Simulate_option_value
透過蒙地卡羅模擬 、二項式評價計算台指選擇權價值，並與Black Scholes方法比較
#三種方法介紹  
1.蒙地卡羅模擬法:假設投資組合的價格變動服從某種隨機過程的行徑程序(Process ），因此可以藉由電腦模擬，大量產生幾百次、幾千次、甚至幾萬次可能價格的路徑，並依此建構投資
組合的報酬分配，進而推估其風險值。  
2.二項式：採用 Cox, Ross, and Rubinstein (1979) 提議，設定  
![image](https://github.com/s930444/Simulate_option_value/assets/169229355/d415f5d4-9064-4265-a447-12289f260ca9)  
該模型假設股價在一段時間內只有兩個可能的方向，上漲或下跌，並且股價的波動率和每個時間段內的概率保持不變。  
3. Black-Scholes模型:憑著其優秀的數學性質、簡易且易用的特性，至今仍是金融機構或投資人愛用的選擇權定價模型。  
![image](https://github.com/s930444/Simulate_option_value/assets/169229355/a963c722-bfed-456c-a18b-78c344a2d37c)  
#策略說明
原始檔案參照option_stock_data.xlsx  
1.以2023/02/01當日的買權資訊為例，計算三種方法的買權價值。  
2.最後列表比較何者最接近真實結果    
#Markdown結果參考Simulate_option_value.pdf  







