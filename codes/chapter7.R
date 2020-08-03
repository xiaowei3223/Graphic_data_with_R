#==========================================================
#添加文本注释
#==========================================================
#使用annotate()和一个文本几何对象
p <- ggplot(faithful, aes(x=eruptions,y=waiting)) + geom_point()

p + annotate("text",x=3, y=48, label="Group 1") +
  annotate("text",x=4.5, y=66, label="Group 2")

#annotate()可以添加任意类型额几何对象
#指定其他文本属性
p + annotate("text",x=3, y=48, label="Group 1", family="serif",
             fontface="italic", colour="darkred",size=3) +
  annotate("text",x=4.5, y=66, label="Group 2", family="serif",
           fontface="italic", colour="darkred",size=3)


#当添加独立的文本对象时，千万不要使用geom_text()。
#annotate(geom="text")会向图形添加一个单独的文本对象
#而geom_text()会根据数据创建许多的文本对象
p + annotate("text",x=3, y=48, label="Group 1", alpha=0.1) +  #正常
  geom_text(x=4.5, y=66, label="Group 2", alpha=0.1)          #遮盖绘制

#如果坐标轴是连续性的，可以使用特殊值Inf和-Inf在绘图区域的边缘放置文本注解
#也需要使用hjust和vjust来调整文本相对于边角的位置
p + annotate("text", x=-Inf, y=Inf, label="Upper left", hjust=-0.2, vjust=2) +
  annotate("text", x=mean.difftime(range(faithful$eruptions)), y=-Inf, vjust=-0.4,
           label="Bottom middle")

#==================================================================
#在注解中使用数学表达式
#==================================================================
#使用annotate(geom="text")并设置parse=TRUE
#一条正态曲线
p <- ggplot(data.frame(x=c(-3,3)), aes(x=x)) + stat_function(fun=dnorm)
p+ annotate("text", x=2, y=0.3, parse=TRUE, 
            label="frac(1,sqrt(2 *pi)) * e^(-x^2/2)")

#要显示两个相邻的变量，需要在两者之间放置一个*操作符
#要显示一个可见的乘号，需要使用%*%
p+ annotate("text", x=0, y=0.05, parse=TRUE, size=4, 
            label="'Function:'* y==frac(1,sqrt(2 *pi)) * e^(-x^2/2)")
#更多数学表达式的示例可见：?plotmath
#数学表达式的图示参见： ?demo(plotmath)

#=================================================================
#添加直线
#=================================================================
#对于横线和竖线，使用geom_hline()和geom_vline()
#对于有角度的直线，使用geom_abline()
library(gcookbook) #为了使用数据
p <- ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=sex)) + geom_point()
#添加横线和竖线
p + geom_hline(yintercept = 60) + geom_vline(xintercept = 14)
#添加有角度的直线
p + geom_abline(intercept = 37.4, slope = 1.75)

#为每一个均值绘制一条水平线
library(plyr) #为了使用ddply()函数
hw_means <- ddply(heightweight, "sex", summarise, heightIn=mean(heightIn))
hw_means
p + geom_hline(aes(yintercept=heightIn, colour=sex), data=hw_means,
               linetype="dashed", size=1)

pg <- ggplot(PlantGrowth, aes(x=group, y=weight)) + geom_point()
pg + geom_vline(xintercept = 2)
pg + geom_vline(xintercept = which(levels(PlantGrowth$group)=="ctrl"))

#==================================================================
#添加线段和箭头
#==================================================================
#使用annotate("segment") 添加线段
library(gcookbook)  #为了使用数据集
p <- ggplot(subset(climate, Source=="Berkeley"), aes(x=Year, y=Anomaly10y)) + 
  geom_line()
p + annotate("segment", x=1950, xend = 1980, y= -0.25, yend = -0.25)

#使用grid包中的arrow()函数向线段两端添加箭头或平头
library(grid)
p + annotate("segment", x=1850, xend = 1820, y=-0.8, yend = -0.95, colour="blue",
             size=2, arrow=arrow()) +
  annotate("segment", x=1950, xend = 1980, y=-0.25, yend = -0.25,
           arrow=arrow(ends = "both", angle = 90, length = unit(0.2, "cm")))
#箭头的默认角度angle是30度，默认长度length是0.2英寸

#=================================================================
#添加矩形阴影
#=================================================================
#使用annotate("rect")
library(gcookbook) #为了使用数据集
p <- ggplot(subset(climate, Source=="Berkeley"), aes(x=Year, y=Anomaly10y)) + 
  geom_line()
p + annotate("rect", xmin=1950, xmax = 1980, ymin = -1, ymax = 1, alpha=0.1,
             fill="blue")

#==================================================================
#高亮某一元素
#==================================================================
#要高亮一个或多个元素，需要在数据中创建一个新列并将其银蛇为颜色
pg <- PlantGrowth
pg$h1 <- "no"
pg$h1[pg$group=="trt2"] <- "yes"
ggplot(pg, aes(x=group, y=weight, fill=h1)) + geom_boxplot() +
  scale_fill_manual(values = c("grey85", "#FFDDCC"), guide=FALSE)
#手工为三个水平逐个设定颜色
ggplot(pg, aes(x=group, y=weight, fill=group)) + geom_boxplot() +
  scale_fill_manual(values = c("grey85", "grey85","#FFDDCC"), guide=FALSE)

#==================================================================
#添加误差线
#==================================================================
#使用geom_errorbar()并将变量映射到ymin和ymax
#对于条形图和折线图，添加误差线的方法相同
library(gcookbook)
ce <- subset(cabbage_exp, Cultivar =="c39")
#为条形图添加误差线
ggplot(ce, aes(x=Date, y=Weight)) +
  geom_bar(stat = "identity",fill="white", colour="black") +
  geom_errorbar(aes(ymin=Weight-se, ymax=Weight+se), width=0.2)
#为折线图添加误差线
ggplot(ce, aes(x=Date, y=Weight)) +
  geom_line(aes(group=1)) +
  geom_point(size=4) +
  geom_errorbar(aes(ymin=Weight-se, ymax=Weight+se), width=0.2)

#反例：未指定并列宽度
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
  geom_bar(stat = "identity",position = "dodge") +
  geom_errorbar(aes(ymin=Weight-se, ymax=Weight+se), position = "dodge",width=0.2)

#正例：设定并列宽度与条形的相同(0.9)
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) +
  geom_bar(stat = "identity",position = "dodge") +
  geom_errorbar(aes(ymin=Weight-se, ymax=Weight+se), 
                position = position_dodge(0.9),width=0.2)

pd <- position_dodge(0.3) #保存并列参数， 因为我们要重复使用它

#对于折线图来说，如果误差线的颜色与线和点的颜色不同，则应线绘制误差线，
#这样它们就会位于点和线的下层了。
#否则，误差线将被绘制在点和线的上层，看起来会不太对。
ggplot(cabbage_exp, aes(x=Date, y=Weight, colour=Cultivar, group=Cultivar)) +
  geom_errorbar(aes(ymin=Weight-se, ymax=Weight+se),
                width=0.2, size=0.25, colour="black", position=pd) +
  geom_line(position=pd) +
  geom_point(position=pd, size=2.5)

#======================================================================
#向独立分面添加注解
#======================================================================
#使用分面变量创建一个新的数据框，并设定每个分面要绘制的值。
#然后配合新数据框使用geom_text()

#基本图形
p <- ggplot(mpg, aes(x=displ, y=hwy)) + geom_point() +
  facet_grid(. ~ drv)

#c存有每个分面所需标签的数据框
f_label <- data.frame(drv=c("4", "f", "r"), label=c("4wd", "Front", "Rear"))

p + geom_text(x=6, y=40, aes(label=label), data=f_label)

#如果你使用annotate()，标签将在所有分面上出现
p + annotate("text", x=6, y=42, label="label text")

#举例子：
#展示每个分面的线性回归曲线、每条曲线的回归公式，以及r2的值
#要完成这件任务，我们将编写一个函数，它可以输入一个数据框并返回另外一个数据框，
#其中包含一个含有回归公式的字符串和一个含r2值的字符串

#此函数返回一个数据框，其中的字符串
#表示回归公式和r^2值得字符串
#这些字符串将被认为是R中得数学表达式
lm_labels <- function(dat){
  mod <- lm(hwy ~ displ, data = dat)
  formula <- sprintf("italc(y) == %.2f %+.2f * italic(x)",
                     round(coef(mod)[1],2), round(coef(mod)[2]))
  
  r <- cor(dat$displ, dat$hwy)
  r2 <- sprintf("italic(R^2) == %.2f", r^2)
  data.frame(formula=formula, r2=r2, stringsAsFactors = FALSE)
}

library(plyr) #为了使用ddply()函数
labels <- ddply(mpg, "drv", lm_labels)
labels

#绘制公式和R^2
p + geom_smooth(method = lm, se=FALSE) +
  geom_text(x=3, y=40, aes(label=formula), data = labels, parse = TRUE, hjust=0) +
  geom_text(x=3, y=35, aes(label=r2), data = labels, parse = TRUE, hjust=0)

#要计算每组得r^2值
labels <- ddply(mpg, "drv", summarise, r2 = cor(displ, hwy)^2)
labels$r2 <- sprintf("italic(R^2) == %.2f", labels$r2)
