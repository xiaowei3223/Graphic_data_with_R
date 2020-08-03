#================================================================
#绘制散点图
#================================================================
plot(mtcars$wt, mtcars$mpg) #普通画法
#使用qplot()绘制散点图
library(ggplot2)
qplot(mtcars$wt, mtcars$mpg)
qplot(wt, mpg, data = mtcars) #与上面等价
ggplot(mtcars, aes(x = wt, y = mpg)) + geom_point() #与上面等价

#===============================================================
#绘制折线图
#===============================================================
#使用plot()函数绘制折线图-----
plot(pressure$temperature,
     pressure$pressure,
     type = "l") #"p"是point，"l" for lines, "b" for both, "c" for the lines part alone of "b", "o" for both "overplotted, "h" for histogram or density
#添加数据点-----
points(pressure$temperature, pressure$pressure)
#添加线-----
lines(pressure$temperature, pressure$pressure/2, col = "red")
#添加数据点-----
points(pressure$temperature, pressure$pressure/2, col = "red")

#使用qplot绘制折线图
qplot(pressure$temperature, pressure$pressure, 
      geom = "line") #geom参数默认为point，如果x是特殊的，默认为histogram
#添加数据点
qplot(pressure$temperature, pressure$pressure, 
      geom = c("line", "point")) #geom参数默认为point，如果x是特殊的，默认为histogram


#使用ggplot绘制折线图
ggplot(pressure, aes(temperature, pressure)) + geom_line()
#添加数据点
ggplot(pressure, aes(temperature, pressure)) + geom_line() + geom_point()

#================================================================
#绘制条形图
#================================================================
barplot(BOD$demand, #设定条形的高度
        names.arg = BOD$Time) #设定每个条形对应的标签（可选）
#利用barplot()绘制频数条形图
barplot(table(mtcars$cyl))

#使用qplot()绘制条形图
library(ggplot2)
#qplot(BOD$Time,BOD$demand, geom = "bar", stat = "identity") #出错了，jie'g结果未知
#将x转化为因子型变量，令系统将其视为离散值
#qplot(factor(BOD$Time),BOD$demand, geom = "bar", stat = "identity") #出错了，jie'g结果未知

#连续x轴和离散x轴的差异
qplot(mtcars$cyl) #cyl是连续变量
qplot(factor(mtcars$cyl)) #cyl是因子变量

#qplot(Time, demand, data = BOD, geom = "bar", stat = "identity") #仍然出错

#频数条形图
ggplot(BOD, aes(x = Time, y = demand)) + geom_bar(stat = "identity")

ggplot(mtcars, aes(x = factor(cyl))) + geom_bar()

#======================================================
#绘制直方图
#======================================================
hist(mtcars$mpg)
hist(mtcars$mpg, breaks = 10) #通过break参数指定大致数组距

#使用qplot()函数
qplot(mtcars$mpg)
qplot(mpg, data = mtcars, binwidth = 4) #组距为4
#等价于
ggplot(mtcars, aes(x = mpg)) + geom_histogram(binwidth = 4)

#======================================================
#绘制箱线图
#======================================================
plot(ToothGrowth$supp, #为因子型变量，与数值型变量对应，plot()会默认绘制箱线图
     ToothGrowth$len)

#当两个参数向量包含在同一个数据框中，可以使用公式语法。
#公式语法允许我们在x轴上使用变量组合
#公式语法
boxplot(len ~ supp, data = ToothGrowth)
#在x轴上引入两变量的交互
boxplot(len ~ supp + dose, data = ToothGrowth)

#使用gplot()函数绘制同样的图形，需要将参数设定为geom = "boxplot"
library(ggplot2)
qplot(ToothGrowth$supp, ToothGrowth$len, geom = "boxplot")

#当两个参数向量在同一个数据框内时，可以使用：
qplot(supp, len, data = ToothGrowth, geom = "boxplot")
#等价于
ggplot(ToothGrowth, aes(x = supp, y = len)) + geom_boxplot()

#使用interation()函数将分组变量组合在一起也可以绘制基于多分组变量的箱线图。
#使用三个独立的向量参数
qplot(interaction(ToothGrowth$supp, ToothGrowth$dose), 
       ToothGrowth$len, geom = "boxplot")
#
qplot(interaction(supp, dose), len, data = ToothGrowth, geom = "boxplot")
#等价于
ggplot(ToothGrowth, aes(x = interaction(supp, dose),y = len)) + geom_boxplot()

#======================================================
#绘制函数图像
#======================================================
#使用curve()函数绘制函数图像
curve(x^3 - 5*x, from=-4, to=4)

#将参数设置为add = TRUE， 可以向已有图形添加函数图像
#绘制用户自定义的函数图像
myfun <- function(xvar){
  1/(1 + exp(-xvar + 10))
}
curve(myfun(x), from = 0, to = 20)
#添加直线
curve(1 - myfun(x), add = TRUE, col = "red")

#使用qplot()函数绘制，需设定stat = "function" 和geom="line"
#并想起传递一个输入和输出皆为数值型向量的函数
library(ggplot2)
#将x轴的取值范围设定为0到20
qplot(c(0,20), fun=myfun, stat = "function", geom = "line")
#这等价于
ggplot(data.frame(x=c(0,20)), aes(x=x)) + stat_function(fun = myfun, geom = "line")

