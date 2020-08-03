#====================================================================
#绘制基本散点图
#====================================================================
#运行geom_point()

library(gcookbook)
#列出我们用到的列
heightweight[, c("ageYear","heightIn")]
ggplot(heightweight, aes(x=ageYear, y=heightIn)) + geom_point()

#通过shape参数可以在散点图中绘制默认值以外的点型。
#如空心圈
ggplot(heightweight, aes(x=ageYear, y=heightIn)) + geom_point(shape=21)

#size参数可以控制图中点的大小
#系统默认的大小size是2
ggplot(heightweight, aes(x=ageYear, y=heightIn)) + geom_point(size=1.5)

#====================================================================
#使用点形和颜色属性，并基于某变量对数据进行分组
#====================================================================
#将分组变量映射给shape和colour属性

library(gcookbook)
#列出要用的三个列
heightweight[, c("sex", "ageYear", "heightIn")]
#通过将变量sex映射给colour或shape，按变量sex对数据点进行分组
library(ggplot2)
ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=sex)) + geom_point()
ggplot(heightweight, aes(x=ageYear, y=heightIn, shape=sex)) + geom_point()
#分组变量必须是分类变量，即必须是因子型或字符串型的向量
ggplot(heightweight, aes(x=ageYear, y=heightIn, shape=sex, colour=sex)) + geom_point()

#可调用scale_shape_manual()函数使用其他点型
#可调用scale_colour_brewer()调用其他调色板
ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=sex)) + 
  geom_point() +
  scale_shape_manual(values = c(1,2)) +
  scale_colour_brewer(palette = "Set1")

#=====================================================================
#使用不同于默认设置的点型
#=====================================================================
#通过指定geom_point()函数中shape，可以设定散点图中所有数据点的点型
library(gcookbook)
ggplot(heightweight, aes(x=ageYear, y=heightIn)) + 
  geom_point(shape=3)
#如果已将分组变量映射给shape，则可以调用scale_shape_manual()函数来修改点型
#使用略大且自定义点型的数据点
ggplot(heightweight, aes(x=ageYear, y=heightIn, shape=sex)) + 
  geom_point(size=3) +
  scale_shape_manual(values = c(1,4))

#生成一个数据副本
hw <- heightweight
#将数据按照是否大于100磅分成两组
hw$weightgroup <- cut(hw$weightLb, breaks = c(-Inf, 100, Inf),
                      labels = c("<100", ">=100"))
#使用具有颜色和填充色的点型及对应于空值NA和填充色的颜色
ggplot(hw, aes(x=ageYear, y=heightIn, shape=sex, fill=weightgroup)) +
  geom_point(size=2.5) +
  scale_shape_manual(values = c(21,24)) +
  scale_fill_manual(values = c(NA, "black"),
                    guide = guide_legend(override.aes = list(shape =21)))

#=====================================================================
#将连续型变量映射到点的颜色或大小属性上
#=====================================================================
#将连续型变量映射到size或colour属性上即可。
library(gcookbook)
#列出要用到的四列
heightweight[,c("sex","ageYear","heightIn","weightLb")]

ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=weightLb)) + geom_point()
ggplot(heightweight, aes(x=ageYear, y=heightIn, size=weightLb)) + geom_point()

#将色阶由黑到白，同时增加数据点的大小，以便于看出填充色
ggplot(heightweight, aes(x=ageYear, y=heightIn, fill=weightLb)) + 
  geom_point(shape=21, size=2.5) +
  scale_fill_gradient(low = "black", high = "white")

#使用guide_legend()函数以高散的图例代替色阶
ggplot(heightweight, aes(x=ageYear, y=heightIn, fill=weightLb)) + 
  geom_point(shape=21, size=2.5) +
  scale_fill_gradient(low = "black", high = "white", 
                      breaks = seq(70, 170, by=20),
                      guide = guide_legend())


ggplot(heightweight, aes(x=ageYear, y=heightIn, size=weightLb, colour=sex)) + 
  geom_point(alpha=0.5) +
  scale_size_area() + #使数据点面积正比于变量值
  scale_color_brewer(palette = "Set1")

#=====================================================================
#处理图形重叠
#=====================================================================
#使用半透明的点
#将数据分箱(bin)，并用矩形表示（适用于量化分析）
#将数据分箱（bin), 并用六边形表示
#使用箱线图

sp <- ggplot(diamonds, aes(x=carat,y=price))
sp + geom_point()

#设定alpha参数可以使数据点半透明，
#alpha=0.1使数据具有90%透明度
sp + geom_point(alpha=0.1)
sp + geom_point(alpha=0.01)

#将数据点分箱（bin)并以矩形来表示，同时将数据点的密度映射为矩形的填充色
#stat_bin_2d()函数分别在x轴和y轴方向上将数据分割为30个组，总计900个箱子
sp + stat_bin2d()
sp + stat_bin2d(bins = 50) +
  scale_fill_gradient(low = "lightblue", high = "red", limits=c(0,6000))
  
#如果不想将数据分箱并以矩形表示的话，可以调用stat_binhex()函数使用六边形代替
if(!require("hexbin"))install.packages("hexbin")
library(hexbin)
sp + stat_binhex() +
  scale_fill_gradient(low = "lightblue", high = "red", limits=c(0,6000))
 
sp + stat_binhex() +
  scale_fill_gradient(low = "lightblue", high = "red", 
                      breaks = c(0,250,500,1000,2000,4000,6000),
                      limits=c(0,6000))

#当散点图的其中一个数据轴或者两个数据轴都对应于离散型数据使，也会出现图形重叠的情况
#可以调用position_jitter()给数据点增加随机扰动
#默认情况下，该函数在每个方向上添加的扰动值为数据点最小精度的40%

sp1 <- ggplot(ChickWeight, aes(x=Time, y=weight))
sp1 + geom_point()
sp1 + geom_point(position = "jitter")
#也可调用geom_jitter()函数，两者是等价的
sp1 + geom_point() + geom_jitter()

sp1 + geom_point(position = position_jitter(width = 5, height = 0))
#=====================================================================
#添加回归模型拟合线
#=====================================================================
#运行stat_smooth()函数并设定method=lm即可向散点图中添加线性回归拟合线
#这将调用lm()函数对数据拟合线性模型
library(gcookbook)
sp <- ggplot(heightweight, aes(x=ageYear, y=heightIn))
sp + geom_point() + stat_smooth(method = lm)
#默认情况下，stat_smooth()函数会为回归拟合线添加95%的置信域
#置信水平可以通过level参数来进行调整。
#设定参数se=FALSE时，系统将不会对回归拟合线添加置信域
#99%置信域
sp + geom_point() + stat_smooth(method = lm, level = 0.99)
#没有置信域
sp + geom_point() + stat_smooth(method = lm, se=FALSE)

#拟合线的默认颜色是蓝色，可以通过设定colour参数对其进行调整
#也可以对拟合线的linetype和size进行设置
sp + geom_point(colour="gray60") +
  stat_smooth(method = lm, se=FALSE, colour="black")

#stat_smooth()默认使用loess曲线
sp + geom_point(colour="gray60") + stat_smooth()
sp + geom_point(colour="gray60") + stat_smooth(method = loess)

#logistic回归
library(MASS) #为了使用数据
b <- biopsy

b$classn[b$class=="benign"] <- 0
b$classn[b$class=="malignant"] <- 0

#令stat_smooth()函数使用选项为family=binomial的glm()函数向散点图添加Logistics回归拟合线
ggplot(b, aes(x=V1, y=classn)) +
  geom_point(position = position_jitter(width = 0.3, height = 0.06),
             alpha=0.4, shape=21, size=1.5) +
  stat_smooth(method = glm, family=binomial)

#如果散点图对应的数据集按照某个因子型变量进行了分组
#将针对各个组分别绘制模型拟合线
#
sps <- ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=sex)) +
  geom_point() +
  scale_color_brewer(palette = "Set1")
sps + geom_smooth()

sps + geom_smooth(method=lm, se=FALSE, fullrange=TRUE)

#====================================================================
#根据已有模型向散点图添加拟合线
#====================================================================
#常用的向散点图添加模型拟合线的方法是调用stat_smooth()函数

library(gcookbook)
model <- lm(heightIn ~ ageYear + I(ageYear^2),heightweight)
model

#创建一个包含变量ageYear的列，并对其进行插值
xmin <- min(heightweight$ageYear)
xmax <- max(heightweight$ageYear)
predicted <- data.frame(ageYear=seq(xmin, xmax, length.out = 100))
#计算变量heightIn的预测值
predicted$heightIn <- predict(model, predicted)
predicted

sp <- ggplot(heightweight, aes(x=ageYear, y=heightIn)) +
  geom_point(colour="gray40")
sp + geom_line(data=predicted, size=1)

#新建一个函数predictvals()简化散点图添加模型拟合线的过程
#根据模型和变量xvar预测变量yvar
#仅支持单一预测变量的模型
#xrange：x轴范围，当值为NULL时，等于模型对象中提取的x轴范围，
#当设定为包含两个数字的向量时，两个数字分别对应于x轴范围的上下限
#sample: x轴上包含样本数量
#...：可传递给predict()函数的其他参数
predictvals <- function(model, xvar, yvar, xrange=NULL, samples=100,...){
  
  #如果xrange没有输入，则从模型对象中自动提取x轴范围作为参数
  #如果xrange参数的方法视模型而定
  if(is.null(xrange)){
    if (any(class(model) %in% c("lm", "glm")))
      xrange <- range(model$model[[xvar]])
    else if (any(class(model) %in% "loess"))
      xrange <- range(model$x)
  }
  
  newdata <- data.frame(x=seq(xrange[1], xrange[2], length.out = samples))
  names(newdata) <- xvar
  newdata[[yvar]] <- predict(model, newdata = newdata, ...)
  newdata
  
}

#调用lm()函数和loess()对数据集建立线型模型和loess模型
modlinear <- lm(heightIn ~ ageYear, heightweight)
modloess <- loess(heightIn ~ ageYear, heightweight)

lm_predicted <- predictvals(modlinear, "ageYear", "heightIn")
loess_predicted <- predictvals(modloess, "ageYear", "heightIn")

sp + geom_line(data = lm_predicted, colour="red", size=0.8) +
  geom_line(data = loess_predicted, colour="blue", size=0.8)

#---------
library(MASS) #为了使用数据
b <- biopsy

b$classn[b$class=="benign"] <- 0
b$classn[b$class=="malignant"] <- 0
#建立Logistics回归模型
fitlogistic <- glm(classn ~ V1, b, family = binomial)
#绘制带扰动和覅他logistic线的散点图
#获取预测值
glm_predicted <- predictvals(fitlogistic, "V1", "classn", type="response")

ggplot(b, aes(x=V1, y=classn)) +
  geom_point(position = position_jitter(width = 0.3, height = 0.08), alpha =0.4,
             shape=21, size=1.5) +
  geom_line(data = glm_predicted, colour="#1177FF", size=1)

#==============================================================
#添加来自多个模型的拟合线
#==============================================================
#使用上文的predictval()函数和来自plyr包中的dlply()及ldply()函数即可
#通过make_model()建立模型
make_model <- function(data){
  lm(heightIn ~ ageYear,data)
}
library(gcookbook)
library(plyr)
models <- dlply(heightweight, "sex", fun=make_model)
models
predvals <- ldply(models, fun=predictvals, xvar="ageYear", yvar="heightIn")
predvals

ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=sex)) +
  geom_point() + geom_line(data=predvals)

predvals <- ldply(models, fun=predictvals, xvar="ageYear", yvar="heightIn",
                  xrange=range(heightweight$ageYear))
ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=sex)) +
  geom_point() + geom_line(data=predvals)
#=================================================================
#向散点图添加模型系数
#=================================================================
#简单的文本以主事形式添加到图形即可
library(gcookbook) #为了使用数据
model <- lm(heightIn ~ ageYear, heightweight)
summary(model)
#首先，生成预测值
pred <- predictvals(model, "ageYear", "heightIn")
sp <- ggplot(heightweight, aes(x=ageYear, y=heightIn)) + geom_point() +
  geom_line(data=pred)
sp + annotate("text", label="r^2=0.42", x= 16.5, y=52)
#设置parse=TRUE调用R的数学表达式语法来输入公式
sp + annotate("text", label="r^2==0.42", parse=TRUE,x= 16.5, y=52)

#=================================================================
#向散点图添加编辑地毯
#=================================================================
#调用geom_rug()即可
ggplot(faithful, aes(x=eruptions, y=waiting)) + geom_point() + geom_rug()
#通过向边际地毯线的位置坐标添加扰动并设定size减小线宽可以减轻边际地毯线的重叠程度
ggplot(faithful, aes(x=eruptions, y=waiting)) + geom_point() + 
  geom_rug(position = "jitter", size=0.2)
#=================================================================
#向散点图添加标签
#=================================================================
#annotate()函数或geom_text()函数可以为一个或几个数据点添加标签
library(gcookbook) #为了使用数据
subset(countries, Year==2009 & healthexp > 2000) #选取人均支出大于2000美元的国家的数据子集
sp <- ggplot(subset(countries, Year==2009 & healthexp > 2000),
             aes(x=healthexp, y=infmortality)) +
  geom_point()
sp + annotate("text", x=4350, y=5.4, label="Canada") +
  annotate("text", x=7400, y=6.8, label="USA")
sp + geom_text(aes(label=Name), size=4)
#设定vjust可以调节文本位置
#vjust=0,标签文本的基线会与数据点对齐
sp + geom_text(aes(label=Name), size=4,vjust=0)
#增加一些y的取值
sp + geom_text(aes(y=infmortality+0.1, label=Name), size=4,vjust=0)
#vjust设置纵向，hjust设置横向
sp + geom_text(aes(label=Name), size=4,hjust=0) #hjust=0左对齐，#hjust=1右对齐
#通过x增加或减去一个值来调整文本标签的位置
sp + geom_text(aes(x=healthexp+100,label=Name), size=4,hjust=0) 

#---如果只想给为数不多的几个点添加标签
cdat <- subset(countries, Year==2009 & healthexp>2000)
cdat$Name1 <- cdat$Name
idx <- cdat$Name1 %in% c("Canada","Iceland","Ireland","Japan","Luxembourg",
                         "Netherlands","New Zealand","Switzerland",
                         "United Kingdom", "United States")
idx
cdat$Name1[!idx] <- NA
ggplot(cdat, aes(x=healthexp,y=infmortality)) +
  geom_point() +
  geom_text(aes(x=healthexp+100,label=Name1), size=4, hjust=0) +
  xlim(2000,10000)
#=======================================================================
#绘制气泡图
#=======================================================================
#调用geom_point()和scale_size_area()即可绘制气泡图
library(gcookbook)
cdat <- subset(countries, Year==2009 & healthexp>2000 &
                 Name %in% c("Canada","Iceland","Ireland","Japan",
                              "Luxembourg","Netherlands","New Zealand",
                              "Switzerland","United Kingdom", "United States"))
cdat
#将GDP映射给半径， scale_size_area()的默认值
p <- ggplot(cdat, aes(x=healthexp, y=infmortality,size=GDP)) +
  geom_point(shape=21, colour="black", fill="cornsilk")
p
#将GDP映射给面积
p + scale_size_area(max_size = 15)

#当x轴和y轴都是分类变量，气泡图可以用来表示网格点上的变量值

#对男性组和女性组求和
hec <- HairEyeColor[,,"Male"] + HairEyeColor[,,"Female"]
#转化为长格式
library(reshape2)
hec <- melt(hec, value.name = "count")
ggplot(hec, aes(x=Eye, y=Hair)) +
  geom_point(aes(size=count), shape=21, colour="black", fill="cornsilk") +
  scale_size_area(max_size = 20, guide=FALSE) +
  geom_text(aes(y=as.numeric(Hair) - sqrt(count)/22, 
                label=count),
            vjust=1, colour="gray60", size=4)
#======================================================================
#绘制散点图矩阵
#======================================================================
#散点图矩阵是一种对多个变量两两之间关系进行可视化的有效方法。
#调用R系统内的pair()可以绘制散点图矩阵
library(gcookbook)
c2009 <- subset(countries, Year ==2009,
                select = c(Name, GDP, laborrate, healthexp, infmortality))
c2009
pairs(c2009[,2:5])
#GGally包中的ggpairs()函数也可以绘制散点图矩阵
