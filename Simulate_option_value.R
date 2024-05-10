setwd("C:\\Users\\user\\Desktop")
library(readxl)
option<- readxl::read_excel("option_stock_data.xlsx",sheet= 1)#讀取選擇權契約及基準日期
risk_free_rate<- readxl::read_excel("option_stock_data.xlsx",sheet= 2)
return_TAIEX<- readxl::read_excel("option_stock_data.xlsx",sheet= 3)#台指期報酬資料
base_date<-option[[1]]#基準日，到期日為2/8
exercise_price<- option[[4]]#履約價格
open_price<-option[[6]]
close_price<-option[[7]]
high_price<-option[[8]]
low_price<-option[[9]]
S0<-as.numeric(return_TAIEX[1728,3],1)
#處理無風險利率 採用台灣銀行一年期定存，並將四年的資料取平均
rfall<-as.data.frame(risk_free_rate[,2])
rf <- mean(rfall[,1])
#計算報酬平均及標準差
mean_return<-mean(as.data.frame(return_TAIEX[,4])[,1]/100)
std_return<-sd(as.data.frame(return_TAIEX[,4])[,1])/100
std_return_year<-std_return*(365^0.5)#年化標準差
#1.蒙地卡羅模擬法
delta_t<-5/252#基準日與到期日距離/252(扣掉假日不計算)
epsilon<-matrix(nrow = 10000,ncol = 5)
for (i in 1:5) {
epsilon[,i]<-rnorm(10000,0,1)#產生7組殘差，每組，服從Normal(0,1)
}
s<-matrix(nrow = 10000,ncol = 5)
delta_S<-matrix(nrow = 10000,ncol = 5)
delta_S[,1]<-mean_return*S0+std_return*S0*epsilon[,1]
s[,1]<-S0+delta_S[,1]
for (j in 1:4) {
    delta_S[,j+1]<-mean_return*s[,j]+std_return*s[,j]*epsilon[,j+1]
    s[,j+1]<-s[,j]+delta_S[,j+1]
}
MAX_ST_X_0 <- s[,5]-exercise_price   #計算選擇權價值
MAX_ST_X_0[which(MAX_ST_X_0<0)]<- 0  #將負值替換為0，公式為max (ST-X,0)
option_value_Monte_Carlo<-mean(MAX_ST_X_0)*exp(-rf*delta_t)
#2.Black Scholes法

d1<-(log(S0/exercise_price)+(rf+(std_return_year^2)/2)*delta_t)/(std_return_year*(delta_t^0.5))
d2<-d1-std_return_year*(delta_t^0.5)
call_value_Black_Scholes<-S0*pnorm(d1)-exercise_price*exp(-rf*delta_t)*pnorm(d2)
cat("以蒙地卡羅估計的買權價值:",option_value_Monte_Carlo)
cat("以Black_Scholes估計的買權價值:",call_value_Black_Scholes)
#3.二項式評價法
library(derivmkts) #用Binomial option pricing的套件
s=S0; k=exercise_price; v=std_return_year; r= rf; tt=delta_t; d=0; nstep=7
call_value_binom<-binomopt(s, k, std_return_year, r, tt, d, nstep, returntrees = TRUE, american=FALSE, putopt=FALSE)[[1]]
cat("以二項式評價估計的買權價值:",call_value_binom)

#結果表格製作
variable_name <-c("計算基準日","μ (daily)","σ (daily)","計算資料時間","S0","X","到期日"
,"無風險利率台銀一年期存款利率","蒙地卡羅模擬結果","二項式結果","Black Scholes結果"
,"當日市場選擇權價格開盤","當日市場選擇權價格最高","當日市場選擇權價格最低","當日市場選擇權價格收盤")
result <- vector(length=15)
result[1]<-as.character.Date(base_date)
result[2]<-round(mean_return,digits = 6)
result[3]<-round(std_return,digits = 6)
result[4]<-paste("2016/01/04","2023/02/01",sep = '-')
result[5]<-S0
result[6]<-exercise_price
result[7]<-"2023/02/08"
result[8]<-rf
result[9]<-round(option_value_Monte_Carlo,digits = 6)
result[10]<-round(call_value_binom,digits = 6)
result[11]<-round(call_value_Black_Scholes,digits = 6)
result[12]<-open_price
result[13]<-high_price
result[14]<-low_price
result[15]<-close_price
final_table<- data.frame(variable_name,result)
library(knitr)
kable(x= final_table,caption= "財務工程作業二",digits =6, row.names = NA, col.names = NA, align= "lr")

