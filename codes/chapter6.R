#==================================================================
#绘制简单直方图
#==================================================================
#运行geom_histogram()函数并映射一个个连续型变量到参数x
library(ggplot2)
ggplot(faithful, aes(x=waiting)) + geom_histogram()
#geom_histogram()函数只需要数据框的其中一列或者一个单独的数据向量作为参数

#将变量值保存为一个基本向量
w <- faithful$waiting
ggplot(NULL, aes(x=w)) + geom_histogram()

#默认情况下，数据被切分为30组。
#可以通过设置binwidth参数来调整数据的分组数

#设定组距为5
ggplot(faithful, aes(x=waiting)) +
  geom_histogram(binwidth = 5, fill="white", colour="black")
#将x的取值切分为15组
binsize <- diff(range(faithful$waiting))/15
ggplot(faithful, aes(x=waiting)) +
  geom_histogram(binwidth = binsize, fill="white", colour="black")

#直方图的外观会非常依赖于组距及组边界
h <- ggplot(faithful, aes(x=waiting)) #将基本绘图结果存为变量以便于重复使用
#设定分组原点boundary
h + geom_histogram(binwidth = 8, fill="white", colour="black", boundary=31)
h + geom_histogram(binwidth = 8, fill="white", colour="black", boundary=35)

#============================================================================
#绘图基于分组数据绘制分组直方图
#============================================================================
#运行geom_histogram()并使用分面绘图
library(MASS) #为了使用数据
#使用smoke作为分面变量
ggplot(birthwt, aes(x=bwt)) +
  geom_histogram(fill="white", colour="black") +
  facet_grid(smoke ~ .)

#修改分面标签
birthwt1 <- birthwt
birthwt1$smoke <- factor(birthwt1$smoke)#将smoke转化为因子
levels(birthwt1$smoke)
library(plyr) #为了使用revalue()函数
birthwt1$smoke <- revalue(birthwt1$smoke, c("0"="No Smoke", "1"="Smoke"))
ggplot(birthwt1, aes(x=bwt)) +
  geom_histogram(fill="white", colour="black") +
  facet_grid(smoke ~ .)

#当各组数据包含的样本数目不同时，可能会难以比较各组数据的分布形状
ggplot(birthwt1, aes(x=bwt)) +
  geom_histogram(fill="white", colour="black") +
  facet_grid(race ~ .)
#设置scales="free"，可以单独设定各个分面的y轴标度
ggplot(birthwt1, aes(x=bwt)) +
  geom_histogram(fill="white", colour="black") +
  facet_grid(race ~ ., scales="free")

#分组绘图的另一种做法是把分组变量映射给fill
#此处的分组变量必须是因子型或字符型的向量
birthwt1 <- birthwt
birthwt1$smoke <- factor(birthwt1$smoke)#将smoke转化为因子
levels(birthwt1$smoke)
#把smoke映射给fill， 取消条形堆叠，并是图形半透明
ggplot(birthwt1, aes(x=bwt, fill=smoke)) +
  geom_histogram(position="identity", #防止垂直堆积
                 alpha=0.4)

#===================================================================
#绘制密度曲线
#===================================================================
#运行geom_density()绘制密度曲线，并映射一个连续变量到x
ggplot(faithful, aes(x=waiting)) + geom_density()

#如果不详绘制图像两侧和底部的线段，可以使用geom_line(stat="density")
#使用expand_limit()函数扩大y轴范围包含0点
ggplot(faithful, aes(x=waiting)) + geom_line(stat = "density") +
  expand_limits(y=0)

#将变量值保存为一个基本向量
w <- faithful$waiting
ggplot(NULL, aes(x=w)) + geom_density()

#核密度曲线是基于样本数据对总体分布做出的一个估计。
#曲线的光滑程度取决于核函数的带宽：带宽越大，曲线越光滑。
#带宽可以通过adjust参数进行设置，其默认值是1
ggplot(faithful, aes(x=waiting)) +
  geom_line(stat = "density", adjust=0.25, colour="red") +
  geom_line(stat = "density") +
  geom_line(stat = "density", adjust=2, colour="blue")

#x轴的坐标范围是自动设定的，以使其能包含相应的数据，但这会导致曲线的边缘被裁剪
#想要展示曲线的更多部分，可以手动设定x轴的范围
#同时设置alpha=0.2使填充色的透明度为80%
ggplot(faithful, aes(x=waiting)) +
  geom_density(fill="blue", alpha=0.2) +
  xlim(35, 105)
#这段代码将使用geom_density()函数绘制一个蓝色多边形，并在顶端添加一条实线
ggplot(faithful, aes(x=waiting)) +
  geom_density(fill="blue", colour=NA,alpha=0.2) +
  geom_line(stat="density") +
  xlim(35, 105)

#将密度曲线叠加到直方图上，可以对观测值的理论分布和实际分布进行比较。
#通过设置y=..density..可以减小直方图的标度以使其与密度曲线的标度相匹配
ggplot(faithful, aes(x=waiting, y=..density..)) +
  geom_histogram(fill="cornsilk", colour="grey60", size=0.2) +
  geom_density() +
  xlim(35, 105)

#========================================================================
#基于分组数据绘制分组密度曲线
#========================================================================
#使用geom_density()函数，将分组变量映射给colour或fill等图形属性
#分组变量必须使因子型或者字符串向量
library(MASS) #为了使用数据
birthwt1 <- birthwt #复制数据的副本
birthwt1$smoke <- factor(birthwt1$smoke) #把变量smoke转化为因子
#把变量映射给colour
ggplot(birthwt1, aes(x=bwt, colour=smoke)) + geom_density()
#把变量映射给fill
ggplot(birthwt1, aes(x=bwt, fill=smoke)) + geom_density(alpha=0.3)

#另一种分组数据分布进行可视化的方法使使用分面（facet)
ggplot(birthwt1, aes(x=bwt)) + geom_density() + facet_grid(smoke~.)
#修改分面的标签
birthwt1 <- birthwt
birthwt1$smoke <- factor(birthwt1$smoke)#将smoke转化为因子
levels(birthwt1$smoke)
library(plyr) #为了使用revalue()函数
birthwt1$smoke <- revalue(birthwt1$smoke, c("0"="No Smoke", "1"="Smoke"))
ggplot(birthwt1, aes(x=bwt)) + geom_density() + facet_grid(smoke~.)

#如果要将直方图和密度曲线绘制在一张图上，最佳方案使利用分面，
#因为将两个直方图绘制在同一张图上的其他方法都不易于解释。
#操作时需设定y=..density.. 这样系统会将直方图的y轴标度降到跟密度曲线相同
ggplot(birthwt1, aes(x=bwt, y=..density..)) +
  geom_histogram(binwidth = 200, fill="cornsilk", colour="gray60", size=0.2) +
  geom_density() +
  facet_grid(smoke ~.)

#=====================================================================
#绘制频数多边形
#=====================================================================
#使用geom_freqpoly()函数即可
ggplot(faithful, aes(x=waiting)) + geom_freqpoly()

#频数多边形看起来跟核密度估计曲线相似，但其传递的信息类似于直方图。
#它跟直方图都描述了数据本身的信息。
#核密度曲线只是一个估计，且需要认为输入带宽参数

#可以通过binwidth参数控制频数多边形的组距
ggplot(faithful, aes(x=waiting)) + geom_freqpoly(binwidth=4)

#通过直接设定每组组距将数据的x轴范围切分为特定数目的组
binsize <- diff(range(faithful$waiting))/15
ggplot(faithful, aes(x=waiting)) + geom_freqpoly(binwidth=binsize)

#=====================================================================
#绘制基本箱线图
#=====================================================================
#使用geom_boxplot()，分别映射一个连续性变量和一个离散型变量到y和x即可
library(MASS) #为了使用数据
ggplot(birthwt, aes(x=factor(race), y=bwt)) + geom_boxplot() #使用factor()函数将数值型变量转化为离散型


#设定width可以修改箱线图的宽度
ggplot(birthwt, aes(x=factor(race), y=bwt)) + geom_boxplot(width=0.5)

#设置outlier.size和outlier.shape修改异常点的大小和点型
ggplot(birthwt, aes(x=factor(race), y=bwt)) + 
  geom_boxplot(outlier.size = 0.5, outlier.shape = 21)

#绘制单组数据的箱线图时，必须给x参数映射一个特定的取值。
#移除x轴的刻度线标记tick marker和标签
ggplot(birthwt, aes(3, y=bwt)) +
  geom_boxplot() +
  scale_x_continuous(breaks = NULL) + 
  theme(axis.title.x = element_blank())

#========================================================================
#向箱线图添加槽口
#========================================================================
#向箱线图添加槽口notch以比较各组数据的中位数
library(MASS) #为了使用数据
ggplot(birthwt, aes(x=factor(race), y=bwt)) + geom_boxplot(notch = TRUE)
#当看到notch went outside hinges. Try setting notch=FALSE.
#说明置信域（槽口）超过了某个箱子的边界
#========================================================================
#向箱线图添加均值
#========================================================================
#使用stat_summary()。箱线图中的均值常以钻石形状来表示
library(MASS) #为了使用数据
ggplot(birthwt, aes(x=factor(race), y=bwt)) + geom_boxplot() +
  stat_summary(fun.y = "mean", geom = "point", shape=23, size=3, fill="white")
#箱线图中间的线表示的是中位数
#========================================================================
#绘制小提琴图
#========================================================================
#小提琴图是多各组数据的密度估计进行比较的
#使用geom_violin()函数即可
library(gcookbook) #为了使用数据
#简单绘图
p <- ggplot(heightweight, aes(x=sex, y=heightIn))
p + geom_violin()
#小提琴图中间叠加一个较窄的箱线图
p + geom_violin() + geom_boxplot(width=0.1, fill="black", outlier.color = NA) +
  stat_summary(fun.y = median, geom="point", fill="white", shape=21, size=2.5)

#设置trim=FALSE可以保留小提琴的尾部
p + geom_violin(trim = FALSE)
#默认情况下，系统会对小提琴图进行标准化以使得各组数据对应的图的面积一样。
#如果trim=TRUE,对数据进行标准化会包括尾部数据

#设置scale="count"使图的面积与每组观测值数目成正比
p + geom_violin(scale = "count")

#使用adjust参数可以调整小提琴图的平滑程度，默认值为1
p + geom_violin(adjust=2)#更平滑
p + geom_violin(adjust=0.5)#欠平滑

#======================================================================
#绘制Wilkinson点图
#======================================================================
#使用geom_dotplot()函数。
library(gcookbook) #为了使用数据
countries2009 <- subset(countries, Year==2009 & healthexp>2009)
p <- ggplot(countries2009, aes(x=infmortality))
p + geom_dotplot()

#使用geom_rug()函数以标示数据点的具体数据
p + geom_dotplot(binwidth = 0.25) + geom_rug() +
  scale_y_continuous(breaks = NULL) +  #移除刻度线
  theme(axis.title.y = element_blank()) #移除坐标轴标签

#默认的dotdensity分组算法，每个数据堆都放置在它表示的数据点的中心位置
#如果需要固定间距的分组算法， 令method="histodot"
p + geom_dotplot(method="histodot",binwidth = 0.25) + geom_rug() +
  scale_y_continuous(breaks = NULL) +  #移除刻度线
  theme(axis.title.y = element_blank()) #移除坐标轴标签

#点图也能进行中心堆叠，
#或者采用一种奇数与偶数数量保持一致的中心堆叠方式。
#可以通过设置stackdir="center"或stackdir="centerwhole"来完成
p + geom_dotplot(stackdir="center",binwidth = 0.25) + geom_rug() +
  scale_y_continuous(breaks = NULL) +  #移除刻度线
  theme(axis.title.y = element_blank()) #移除坐标轴标签

p + geom_dotplot(stackdir="centerwhole",binwidth = 0.25) + geom_rug() +
  scale_y_continuous(breaks = NULL) +  #移除刻度线
  theme(axis.title.y = element_blank()) #移除坐标轴标签

#===================================================================
#基于分组数据绘制分组点图
#===================================================================
#设定binaxis="y"将数据点沿着y轴进行堆叠，并沿着x轴分组
library(gcookbook) #为了使用数据
ggplot(heightweight, aes(x=sex, y=heightIn)) + 
  geom_dotplot(binaxis = "y", binwidth = 0.5, stackdir = "center")

#将点图叠加在箱线图上
ggplot(heightweight, aes(x=sex, y=heightIn)) + 
  geom_boxplot(outlier.colour = NA, width=0.4) +
  geom_dotplot(binaxis = "y", binwidth = 0.5, stackdir = "center", fill=NA)

#通过scale_x_continuous()函数使得x轴的刻度标签显示为与银子水平相对应的文本
ggplot(heightweight, aes(x=sex, y=heightIn)) + 
  geom_boxplot(aes(x=as.numeric(sex) + 0.2, group=sex), width=0.25) +
  geom_dotplot(aes(x=as.numeric(sex) - 0.2, group=sex),binaxis = "y", 
               binwidth = 0.5, stackdir = "center") +
  scale_x_continuous(breaks = 1:nlevels(heightweight$sex),
                     labels = levels(heightweight$sex))

#======================================================================
#绘制二维数据的密度图
#======================================================================
#使用stat_density2d()函数。

#基础图
p <- ggplot(faithful, aes(x=eruptions, y=waiting))
p + geom_point() + stat_density2d()

#使用..level..将密度曲面的高度映射给等高线的颜色
#将height映射给颜色的等高线
p + geom_point() + stat_density2d(aes(colour=..level..))

#使用瓦片图tile将密度估计映射给填充色或瓦片图的透明度
#将密度估计映射给填充色
p + stat_density2d(aes(fill=..density..), geom="raster", contour = FALSE)

#带数据点，并将密度估计映射给alpha的瓦片图
p + geom_point() +
  stat_density2d(aes(alpha=..density..), geom="tile", contour = FALSE)

#传递一个指定x和y贷款的向量到h。
#这个参数会被传递给直接生成密度估计的函数kde2d()。
p + stat_density2d(aes(fill=..density..), geom="raster", 
                   contour = FALSE,h = c(0.5,5))
