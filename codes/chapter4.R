#===========================================================================
#绘制简单折线图
#===========================================================================
#运行ggplot()和geom_line()函数，分别指定一个变量映射给x和y
ggplot(BOD, aes(x=Time, y=demand)) + geom_line()

#折线图的x轴既可以是离散型（分类）变量，也可以是连续型（数值型）变量
#当x是因子型变量使，必须使用aes(group=1)以确保ggplot()知道这些数据点属于同一个分组，
#从而应该用一条折线连在一起
BOD1 <- BOD
BOD1$Time <- factor(BOD1$Time)
ggplot(BOD1, aes(x=Time, y=demand, group = 1)) + geom_line()

#默认情况下，ggplot2绘制的折线图的y轴范围刚好能容纳数据集中的y值
#对于某些数据而言，将y轴的起点设定为0更合适。
#使用ylim()设定y轴范围或运行含一个参数的expand_limit()扩展y轴的范围
ggplot(BOD, aes(x=Time,y=demand)) + geom_line() + ylim(0, max(BOD$demand))
ggplot(BOD, aes(x=Time,y=demand)) + geom_line() + expand_limits(y = 0)

#==========================================================================
#向折线图添加数据标记
#==========================================================================
#在代码中加上geom_point()
ggplot(BOD, aes(x=Time,y=demand)) + geom_line() + geom_point()

#在折线图上添加数据标记可以体现数据点的密度较低或者数据采集频率不规则。
#worldpop数据集对应的采集时间间隔不是常数
library(gcookbook) #为了使用数据
ggplot(worldpop, aes(x=Year, y=Population)) + geom_line() + geom_point()
#当y轴取对数也一样
ggplot(worldpop, aes(x=Year, y=Population)) + geom_line() + geom_point() +
  scale_y_log10()

#==========================================================================
#绘制多重折线图
#==========================================================================
#在分别设定一个映射给x和y的基础上，再将另外一个离散型变量映射给颜色colour或者线型linetype

#载入plyr包，便于我们使用ddply()函数创建样本数据集
library(plyr)
#对ToothGrowth数据集进行汇总
tg <- ddply(ToothGrowth, c("supp", "dose"), summarise, length = mean(len))

#将supp映射给颜色
ggplot(tg, aes(x=dose,y=length,colour=supp)) + geom_line()
#将supp映射给线型
ggplot(tg, aes(x=dose,y=length,linetype=supp)) + geom_line()
#x是因子型（分类）变量时
ggplot(tg, aes(x=factor(dose),y=length, colour=supp, group=supp)) + geom_line()
#当分组不正确时
ggplot(tg, aes(x=dose,y=length)) + geom_line()

#如果折线图上有数据标记，可以将分组变量映射给数据标记的属性，诸如shape和fill等
ggplot(tg, aes(x=dose, y=length,shape=supp)) + geom_line() + 
  geom_point(size=4) #更大的点 
ggplot(tg, aes(x=dose, y=length,fill=supp)) + geom_line() + 
  geom_point(size=4, shape=21) #更大的点 

#有时，数据标记会相互重叠，需要令其错开
#意味着要将它们的位置左移或者右移。
ggplot(tg, aes(x=dose, y=length,shape=supp)) + 
  geom_line(position = position_dodge(0.2)) + #将连接先左右移动0.2 
  geom_point(position = position_dodge(0.2), size=4) #将点的位置左右移动0.2

#==========================================================================
#修改线条样式
#==========================================================================
#通过设置线型（linetype）、线宽（size）和颜色（colour)参数可以分别修改折线的线型、线宽、颜色
#将这些参数的值传递给geom_line()函数可以设置折线图的对应属性
ggplot(BOD, aes(x=Time, y=demand)) +
  geom_line(linetype="dashed", size=1, colour="blue")

#对于多重折线图而言，设定图形属性会对图上的所有折线产生影响。
#而将变量映射给图形属性则会使图上的折线具有不同的外观
#调用scale_colour_brewer()和scale_colour_manual()函数为图形着色

#加载plyr包，便于调用ddply()函数创建例子所需的数据集
library(plyr)
#对ToothGrowth数据集进行汇总
tg <- ddply(ToothGrowth, c("supp", "dose"), summarise, length=mean(len))
ggplot(tg, aes(x=dose, y=length, colour=supp)) +
  geom_line()+
  scale_color_brewer(palette = "Set1")

#在aes()函数外部设定颜色（colour)会将所有折线设定为同样的颜色。
#其他图形属性如线宽size、线型linetype、点型shape与此类似

#如果两条折线的图形属性相同，需要指定一个分组变量
ggplot(tg, aes(x=dose, y=length, group=supp)) +
  geom_line(colour="darkgreen", size=1.5)
#因为变量supp被映射给了颜色colour属性，所以，它自动作为分组变量
ggplot(tg, aes(x=dose, y=length, colour=supp)) +
  geom_line(linetype="dashed") +
  geom_point(shape=22, size=3, fill="white")

#======================================================================
#修改数据标记样式
#======================================================================
#在aes()外部设定函数geom_point()的大小size、颜色colour和填充色fill即可
ggplot(BOD, aes(x=Time, y=demand)) +
  geom_line() +
  geom_point(size=4, shape=22, colour="darkred", fill="pink")  

#数据标记默认的形状shape是实线圆圈，
#默认的大小size是2，
#默认的颜色colour是黑色
#填充色fill属性只适用于某些具有独立边框线和填充颜色的点形
ggplot(BOD, aes(x=Time, y=demand)) +
  geom_line() +
  geom_point(size=4, shape=21,fill="white")

#载入plyr包，以使用ddply()函数创建例子所需数据库
library(plyr)
#对ToothGrowth数据集进行汇总
tg <- ddply(ToothGrowth, c("supp", "dose"), summarise, length=mean(len))

#保存错开(dodge)设置，接下来会多次用到
pd <- position_dodge(0.2)
ggplot(tg, aes(x=dose, y=length, fill=supp)) +
  geom_line(position = pd) +
  geom_point(shape=21, size=3, position = pd) +
  scale_fill_manual(values = c("black", "white"))

#======================================================================
#绘制面积图
#======================================================================
#运行geom_area()函数即可绘制面积图

#将sunspot.year数据集转化数据框，便于本例使用
sunspotyear <- data.frame(
  Year = as.numeric(time(sunspot.year)),
  sunspots = as.numeric(sunspot.year)
)
ggplot(sunspotyear, aes(x=Year, y=sunspots)) + geom_area()

#设定填充色fill可以修改面积图的填充色
#设定alpha=0.2，将面积图的透明度设定为80%
ggplot(sunspotyear, aes(x=Year, y=sunspots)) +
  geom_area(colour="black", fill="blue", alpha=0.2)

#系统会在面积图的起点和和终点位置分别绘制一套垂直线，且在底部绘制了一条横线
#为了修正这种情况，可以先绘制不带边框线的面积图（不设定colour）
#添加新图层，并用geom_line()函数绘制轨迹线
ggplot(sunspotyear, aes(x=Year, y=sunspots)) +
  geom_area(fill="blue", alpha=0.2) +
  geom_line()

#=====================================================================
#绘制堆积面积图
#=====================================================================
#运行geom_are()函数，并映射一个因子型变量给填充色（fill)即可。
library(gcookbook) 
ggplot(uspopage, aes(x=Year, y=Thousands, fill=AgeGroup)) + geom_area()

#堆积面积图对应的基础数据通常为宽格式（wide format)
#ggplot2要求数据必须是长格式 long format
#在两种格式之间进行转换的内容

#反转图例堆积顺序、带面积分割线并调用其他调色板的堆积面积图
ggplot(uspopage, aes(x=Year, y=Thousands, fill=AgeGroup)) +
  geom_area(colour="black", size=0.2, alpha=0.4) +
  scale_fill_brewer(palette = "Blues", breaks=rev(levels(uspopage$AgeGroup)))

#反转堆积顺序的堆积面积图
library(plyr) #为了使用desc()函数
ggplot(uspopage, aes(x=Year, y=Thousands, fill=AgeGroup, order=desc(AgeGroup)))  +
  geom_area(colour="black", size=0.2, alpha =0.4) +
  scale_fill_brewer(palette = "Blues")

#没有左右边框的堆积面积图
ggplot(uspopage, aes(x=Year, y=Thousands, fill=AgeGroup, order=desc(AgeGroup)))  +
  geom_area(colour="NA",alpha =0.4) +
  scale_fill_brewer(palette = "Blues") +
  geom_line(position = "stack", size=0.2)

#========================================================================
#绘制百分比堆积面积图
#========================================================================
#计算各组对应的百分比。
#调用ddply()函数按变量Year对uspopage进行分组，计算
library(gcookbook) #为了使用数据
library(plyr) #为了使用ddply()函数
uspopage_prop <- ddply(uspopage, "Year", transform, 
                    Percent = Thousands/sum(Thousands) * 100)
library(ggplot2)
ggplot(uspopage_prop, aes(x=Year, y=Percent, fill=AgeGroup)) +
  geom_area(colour="Black", size=0.2, alpha=0.4) +
  scale_fill_brewer(palette = "Blues", breaks=rev(levels(uspopage$AgeGroup)))

#========================================================================
#添加置信域
#========================================================================
#运行geom_ribbon()， 然后分别映射一个变量给ymin和ymax

library(gcookbook) #为了使用数据
#抓取climate数据集的一个子集
clim <- subset(climate, Source == "Berkeley",
               select = c("Year", "Anomaly10y", "Unc10y"))
head(clim)
#将置信域绘制为阴影
ggplot(clim, aes(x=Year, y=Anomaly10y)) +
  geom_ribbon(aes(ymin=Anomaly10y-Unc10y,ymax=Anomaly10y+Unc10y )) +
  geom_line()
#注意，geom_ribbon()应在geom_line()之上

#使用虚线表示置信域的上下边界
ggplot(clim, aes(x=Year, y=Anomaly10y)) +
  geom_line(aes(y=Anomaly10y-Unc10y), colour="gray50", linetype="dotted") +
  geom_line(aes(y=Anomaly10y+Unc10y), colour="gray50", linetype="dotted") +
  geom_line()
