library(ggplot2)
#============================================================
#交换x轴和y轴
#============================================================
#使用coord_flip()来翻转坐标轴
ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot()
ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot() + coord_flip()

#如果x变量是一个因子型变量，
#则排列顺序可以通过使用scale_x_discrete()和参数limits=rev(levels(...))反转
ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot() + 
  coord_flip() +
  scale_x_discrete(limits=rev(levels(PlantGrowth$group)))

#============================================================
#设置连续性坐标轴的值域
#============================================================
#使用xlim()和ylim()来设置一条连续型坐标轴的最小值和最大值
p <- ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot()
p
p + ylim(0, max(PlantGrowth$weight))

#ylim()来设定范围是通过scale_y_continuous()来设定范围的简便写法
#对于xlim()和scale_x_continuous()同理
#ylim(0,10) 
#等价于
#scale_y_continuous(limits=c(0,10))

#ylim()和scale_y_continuous()同时使用，只有命令中的后一条会生效
p + ylim(0,10) + scale_y_continuous(breaks = c(0,5,10))

p + scale_y_continuous(breaks = c(0,5,10)) + ylim(0,10) 

#舍弃ylim()，使用scale_y_continuous(),并设定limits和breaks
p + scale_y_continuous(limits = c(0,10), breaks = c(0,5,10))

#ggplot2中有两种设置坐标轴值域的方法。
#第一种方法： 修改标度
#超出范围的数据不仅不会被展示，而且会被完全移除
#第二种方法： 应用一个坐标转换
#数据不会被修建，只是将数据放大或缩小到指定的范围
p + scale_y_continuous(limits = c(5,6.5)) #与使用ylim()相同
p + coord_cartesian(ylim = c(5,6.5))
p + scale_y_continuous(limits = c(0,6.5))

#使用expand_limits()单向扩展值域
p + expand_limits(y=0)

#============================================================
#反转一条连续型坐标轴
#============================================================
#使用scale_y_reverse或scale_x_reverse
#坐标轴的方向也可通过指定反序的范围来反转，先写最大值，再写最小值
ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot() + scale_y_reverse()

#通过指定反序的范围产生类似的效果
ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot() + ylim(6.5, 3.5)

ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot() + 
  scale_y_reverse(limits=c(8,0))
#=============================================================
#修改类被行坐标轴上项目的顺序
#=============================================================
#对于类别型（离散型）坐标轴上来说，会有一个因子型变量映射到它上面
#坐标轴上项目的顺序可以设定scale_x_discrete()或scale_y_discrete()中的参数limits来修改


p <- ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot()
p + scale_x_discrete(limits=c("trt1","ctrl","trt2"))
p + scale_x_discrete(limits=c("trt1","ctrl"))
p + scale_x_discrete(limits=rev(levels(PlantGrowth$group)))

#=============================================================
#设置x轴和y轴的缩放比例
#=============================================================
#使用coord_fixed()，以下代码将得到x轴和y轴之间1：1的缩放结果
library(gcookbook) #为了使用数据集
sp <- ggplot(marathon, aes(x=Half, y=Full)) + geom_point()
sp + coord_fixed()

#通过在scale_y_continuous()和scale_x_continuous()中调整参数breaks
#将刻度间距设为相同
sp + coord_fixed() +
  scale_y_continuous(breaks = seq(0, 420, 30)) +
  scale_x_continuous(breaks = seq(0, 420, 30))

#设置参数ratio使两个坐标轴之间指定其他的固定比例而非相同的比例
#在x轴上添加双倍的刻度线
sp + coord_fixed(ratio =1/2) +
  scale_y_continuous(breaks = seq(0, 420, 30)) +
  scale_x_continuous(breaks = seq(0, 420, 30))

#================================================================
#设置刻度线的位置
#================================================================
#如果需要改变刻度线在坐标轴的位置，设置breaks参数即可
ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot()
ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot() +
  scale_y_continuous(breaks = c(4, 4.25, 4.5, 5, 6, 8))
#也可以使用seq()函数或运算符，来生成刻度线的位置向量
seq(4, 7, by=.5)

#如果坐标轴使离散型而不是连续型，默认会为每个项目生成一条刻度线
#对于离散型坐标轴，可以通过指定limits()来修改项目的顺序或移除项目
#设置limits重排序或移除项目，设置breaks控制那些项目拥有标签
ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot() +
  scale_x_discrete(limits=c("trt2", "ctrl"),breaks = "ctrl")

#================================================================
#移除刻度线和标签
#================================================================
#移除y轴刻度标签，使用theme(axis.text.y = element_blank())
#移除x轴刻度标签，使用theme(axis.text.x = element_blank())

p <- ggplot(PlantGrowth, aes(x=group, y= weight)) + geom_boxplot()
p + theme(axis.text.y = element_blank())

#移除刻度线，使用theme(axis.ticks = element_blank())
p + theme(axis.ticks = element_blank(), axis.text.y = element_blank())

#要移除刻度线、刻度标签和网格线， 将break设置为NULL即可
p + scale_y_continuous(breaks = NULL)

#对于连续性坐标轴，ggplot()通常会在每个breaks值得位置放置刻度线、刻度标签和主网格线
#对于离散型坐标轴，这些元素则出现在每个limits值的位置上。

#==============================================================
#修改刻度标签的文本
#==============================================================
#在标度中为breaks和labels赋值即可
library(gcookbook) #为了使用数据集
hwp <- ggplot(heightweight,aes(x=ageYear, y=heightIn)) +
  geom_point()
hwp
hwp + scale_y_continuous(breaks = c(50,56,60,66,72),
                         labels = c("Tiny","Really\nshort","short",
                                    "Medium", "Tallish"))

#让数据以某种格式存储-----
#函数将英寸数值转换为英尺加英寸的格式
footinch_formatter <- function(x){
  foot <- floor(x/12)
  inch <- x %% 12
  return(paste(foot, "'", inch, "\"",sep = ""))
}
footinch_formatter(56:64)
#参数labels把函数传递给标度
hwp + scale_y_continuous(labels = footinch_formatter)

hwp + scale_y_continuous(breaks = seq(48,72,4),
                         labels = footinch_formatter)

#=================================================================
#修改刻度标签的外观
#=================================================================
bp <- ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot() +
  scale_x_discrete(breaks=c("ctrl", "trt1", "trt2"),
                   labels=c("Control", "Treatment 1", "Treatment 2"))
bp

#将文本逆时针旋转90度
bp + theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
#将文本逆时针旋转30度
bp + theme(axis.text.x = element_text(angle = 30, hjust = 1, vjust = 0.5))

#hjust设置横向对齐、
#vjust设置纵向对齐

#除了旋转意外，其他的文本属性，如大小、样式（粗体、斜体、常规）
#和字体族（Times或Helvetica)可以使用element_text()进行设置
bp + theme(axis.text.x = element_text(family = "Times", face = "italic",
                                      colour = "darkred", 
                                      size = rel(0.9))) #当前主题基础字体大小的0.9倍

#==================================================================
#修改坐标轴标签的文本
#==================================================================
#使用xlab()或ylab()来修改坐标轴标签的文本
library(gcookbook) #为了使用数据集

hwp <- ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=sex)) +
  geom_point()
#使用默认的坐标轴标签
hwp
#设置坐标轴标签
hwp + xlab("Age in years") + ylab("Height in inches")

#除了使用xlab()和ylab()，也可以使用labs()
hwp + labs(x="Age in years", y="Height in inches")

#另一种设置坐标轴标签方法是在标度中指定
hwp + scale_x_continuous(name = "Age in years")
#这种方法同样适用于其他的坐标轴标度
#如： scale_y_continuous()、scale_x_discrete()等

#还可以使用\n来添加换行
hwp + scale_x_continuous(name = "Age\n(Years)")

#=============================================================
#移除坐标轴标签
#=============================================================
#对于x轴标签，使用theme(axis.title.x=element_blank())
#对于y轴标签，使用theme(axis.title.y=element_blank())
p <- ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_boxplot()
p + theme(axis.title.x = element_blank())

#移除坐标轴标签的另一种方法是将其设为一个空字符串
p + xlab("")

#使用theme(axis.title.x=element_blank()), x、y标度的名称是不会改变的，
#只是这样不会显示文本而且不会为其留出空间
#设置标签为"",标度的名称就改变了，实际上显示了空白的文本

#===============================================================
#修改坐标轴标签的外观
#===============================================================
#要修改x轴标签的外观，使用axis.title.x即可
library(gcookbook) #为了使用数据集
hwp <- ggplot(heightweight, aes(x=ageYear, y=heightIn)) + geom_point()
hwp + theme(axis.title.x = element_text(face = "italic", colour = "darkred", size = 14))

#标签中\n表示另起一行
hwp + ylab("Height\n(inches)") +
  theme(axis.title.y = element_text(angle = 0, face = "italic", size = 14))
#当调用element_text()时，默认的角度时0，
#所以如果设置了axis.title.y但没有指定这个角度，它将以文本的顶部指向上方的朝向显示
hwp + ylab("Height\n(inches)") +
  theme(axis.title.y = element_text(angle = 90, face = "italic", size = 14))

#===============================================================
#沿坐标轴显示直线
#===============================================================
#使用主题设置中的axis.line
library(gcookbook)
p <- ggplot(heightweight, aes(x=ageYear, y=heightIn)) + geom_point()
p + theme(axis.line = element_line(colour = "black"))

#增加重置参数panel.border
p + theme_bw() + 
  theme(panel.border = element_blank(),
        axis.line = element_line(colour = "black"))

#使末端的边界线完全重叠，设置linneed="square"：-----

#对于较粗的线条，只有一半重叠
p + theme_bw() + 
  theme(panel.border = element_blank(),
        axis.line = element_line(colour = "black",size = 4))
#完全重叠
p + theme_bw() + 
  theme(panel.border = element_blank(),
        axis.line = element_line(colour = "black", size = 4, lineend = "square"))

#==============================================================
#使用对数坐标轴
#====================================================================
#使用scale_x_log10()和或scale_y_log10()
library(MASS) #为了使用数据集
#基本图形
p <- ggplot(Animals, aes(x=body, y=brain, label=rownames(Animals))) +
  geom_text(size=3)
p
#使用对数x标度和对数y标度
p + scale_x_log10() + scale_y_log10()

p + scale_x_log10(breaks=10^(-1:5)) + scale_y_log10(10^(0:3))

#要让刻度标签转而使用指数记数法，只要使用scales包中的函数trans_format()
library(scales)
p + scale_x_log10(breaks=10^(-1:5),
                  labels=trans_format("log10", math_format(10^.x))) +
  scale_y_log10(breaks=10^(0:3),
                labels=trans_format("log10",math_format(10^.x)))

#使用对数坐标轴的另一种方法是：
#在将数据映射到x和y坐标之前，先对其进行变换，从技术上，坐标轴仍然是线性的--它表示对数变换后的数值
ggplot(Animals, aes(x=log10(body), y=log10(brain), label=rownames(Animals))) +
  geom_text(size=3)

#对x使用自然对数变换，对y使用log2变换
p + scale_x_continuous(trans = log_trans(),
                       breaks = trans_breaks("log", function(x) exp(x)),
                       labels = trans_format("log", math_format(e^.x))) +
  scale_y_continuous(trans = log2_trans(),
                     breaks = trans_breaks("log2",function(x) 2^x),
                     labels = trans_format("log2", math_format(2^.x)))

#分别使用线性和对数的y轴来展示苹果公司的股价变化情况
library(gcookbook)  #为了使用数据集
ggplot(aapl, aes(x=date,y=adj_price)) + geom_line()
ggplot(aapl, aes(x=date,y=adj_price)) + geom_line() +
  scale_y_log10(breaks=c(2,10,50,250))
#==============================================================
#为对数坐标轴添加刻度
#==============================================================
#使用annotation_logticks()

library(MASS) #为了使用数据集
library(scales) #为了使用trans和format相关函数
ggplot(Animals, aes(x=body, y=brain, label=rownames(Animals))) +
  geom_text(size=3) +
  annotation_logticks() +
  scale_x_log10(breaks=10^(-1:5),
                labels=trans_format("log10", math_format(10^.x))) +
  scale_y_log10(breaks=10^(0:3),
                labels=trans_format("log10",math_format(10^.x)))

ggplot(Animals, aes(x=body, y=brain, label=rownames(Animals))) +
  geom_text(size=3) +
  annotation_logticks() +
  scale_x_log10(breaks=trans_breaks("log10", function(x) 10^x),
                labels=trans_format("log10", math_format(10^.x)),
                minor_breaks = log10(5) + -2:5) +
  scale_y_log10(breaks=trans_breaks("log10", function(x) 10^x),
                labels=trans_format("log10",math_format(10^.x)),
                minor_breaks = log10(5) + -1:3) +
  coord_fixed() +
  theme_bw()
#========================================================
#绘制环状图形
#========================================================
#使用coord_polar()

library(gcookbook) #为了使用数据
head(wind)

#使用geom_histogram()对每个SpeedCat和DirCat的类别绘制样本数量的计数值。
#将binwidth设置为15以使直方图的origin开始与-7.5的位置，
#这样每个扇形就会居中于0、15、30等位置。
ggplot(wind, aes(x=DirCat,fill=SpeedCat)) +
  geom_histogram(binwidth = 15, drgin=-7.5) +
  coord_polar() +
  scale_x_continuous(limits = c(0,360))

#可以通过反转图例、使用不同的调色板、添加外框线以及将分割点设置为某些更熟悉的值的方式，让图形稍微美观一些
ggplot(wind, aes(x=DirCat,fill=SpeedCat)) +
  geom_histogram(binwidth = 15, drgin=-7.5,colour="black",size=0.25) +
  coord_polar() +
  scale_x_continuous(limits = c(0,360),breaks = seq(0,360,by=45),
                     minor_breaks = seq(0,360,by=15))+
  scale_fill_brewer()

#在使用一个连续性的x是，数据中的最小值和最大值是重合的，有时需要设置对应的界限

#将mdeaths的时间序列数据放入一个数据框
md <- data.frame(deaths=as.numeric(mdeaths),
                 month = as.numeric(cycle(mdeaths)))
#计算每个月的平均死亡数量
library(plyr)
md <- ddply(md, "month",summarise,deaths=mean(deaths))
md
#绘制基本图形
p <- ggplot(md, aes(x=month,y=deaths)) + geom_line() +
  scale_x_continuous(breaks = 1:12)
#使用coord_polar
p + coord_polar()

#使用coord_polar并将y(r)的下界设置为0
p + coord_polar() + ylim(0, max(md$deaths))

p + coord_polar() + ylim(0, max(md$deaths)) + xlim(0,12)

#通过添加一个值与12的值相同的0来连接曲线
mdx <- md[md$month==12,]
mdx$month <- 0
mdnew <- rbind(mdx,md)
#通过使用%+% 绘制与之前相同的图形，只是使用的数据不同
p %+% mdnew + coord_polar() + ylim(0,max(md$deaths))
#================================================================
#在坐标轴上使用日期
#================================================================
#将一列类为Date的变量映射到x轴或y轴

#观察数据结构
str(economics) 
ggplot(economics, aes(x=date, y=psavert)) + geom_line()

#ggplot2可以处理两类时间相关的对象，日期对象(Date)和日期时间对象（POSIXt）
#Date对象表示的是日期，分别率为一天
#POSIXt对象是时刻，拥有精确到秒的小数部分的分辨率

#去economics的一个子集
econ <- subset(economics, date >= as.Date("1992-05-01") &
                          date < as.Date("1993-06-01"))
#基本图形---不指定分割点
p <- ggplot(econ, aes(x=date, y=psavert)) + geom_line()
p

#指定一个日期向量为分割点
datebreaks <- seq(as.Date("1992-06-01"), as.Date("1993-06-01"), by="2 month")
#使用分割点并旋转文本标签
p + scale_x_date(breaks = datebreaks) +
  theme(axis.text.x = element_text(angle = 30,hjust = 1))

#注意：这里分割点（标签）的格式发生了改变，可以通过使用scales包中的date_format()函数来指定格式。
library(scales)
p + scale_x_date(breaks = datebreaks, labels = date_format("%Y %b")) +
  theme(axis.text.x = element_text(angle = 30,hjust = 1))

#=============================================================
#在坐标轴上使用相对时间
#=============================================================
#时间值通常以数字的形式存储
#当将一个值映射到x轴或y轴上，并使用一个格式刷来生成合适的坐标轴标签

#转换时间序列对象WWWusage为数据框
www <- data.frame(minute = as.numeric(time(WWWusage)),
                  users = as.numeric(WWWusage))
#定义一个格式刷函数--可将以分钟表示的时间转换为字符串
timeHM_formatter <- function(x){
  h <- floor(x/60)
  m <- floor(x %% 60)
  lab <- sprintf("%d:%02d", h, m) #将字符串格式化为HH:MM(时:分)的格式
  return(lab)
}

#默认的x轴
ggplot(www, aes(x=minute,y=users)) + geom_line()
#使用格式化后的时间
ggplot(www, aes(x=minute,y=users)) + geom_line() +
  scale_x_continuous(name = "time", breaks = seq(0,100, by=10),
                     labels = timeHM_formatter)
