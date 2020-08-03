
#=========================================================================================
#设置对象的颜色
#=========================================================================================
#设置colour或者fill参数的值
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()

library(MASS) #为了使用数据集
ggplot(birthwt, aes(x=bwt)) + geom_histogram(fill="red", colour="black")

#colour参数控制的是线条、多边形轮廓的颜色，
#fill参数控制的是多边形的填充色。
#对于点型来说，colour控制的是整个点的颜色，而不是fill
#=========================================================================================
#将变量映射到颜色上
#=========================================================================================
#将colour或fill参数的值设置为数据中某一列的列名即可。

library(gcookbook) #为了使用数据集
#这两种方法效果相同
ggplot(cabbage_exp, aes(x=Date, y=Weight, fill=Cultivar)) + 
  geom_bar(colour="black", position = "dodge",stat = "identity")

ggplot(cabbage_exp, aes(x=Date, y=Weight)) + 
  geom_bar(aes(fill=Cultivar), colour="black", position = "dodge", stat = "identity")

#这两种方法效果相同
ggplot(mtcars, aes(x=wt, y=mpg, colour=cyl)) + geom_point()
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point(aes(colour=cyl))

#在ggplot()中因子化
ggplot(mtcars, aes(x=wt, y=mpg, colour=factor(cyl))) + geom_point()

#另一个方法：在原数据中因子化
m <- mtcars #复制mtcars
m$cyl <- factor(m$cyl) #将cyl转化为因子
ggplot(m, aes(x=wt, y=mpg, colour=cyl)) + geom_point()

#=========================================================================================
#对离散型变量使用不同的调色板
#=========================================================================================
#使用默认调色板和ColorBrewer调色板
library(gcookbook) #为了使用数据集
#基础图形
p <- ggplot(uspopage, aes(x=Year, y=Thousands, fill=AgeGroup)) + geom_area()
#这三种方法效果相同
p 
p + scale_fill_discrete()
p + scale_fill_hue()
#ColorBrewer调色板
p + scale_fill_brewer()

#修改调色板就是修改填充色标度(fill)或轮廓色标度（colour），
#会涉及从连续性或离散型变量到图形属性上映射的改变。
#在颜色上有两个类型的标度，填充色标度和轮廓色标度

#基本的散点图
h <- ggplot(heightweight, aes(x=ageYear,y=heightIn,colour=sex)) + geom_point()
#默认亮度lightness = 65
h
#略微加深
h + scale_colour_hue()

#查看ColorBrewer包提供的调色板
library(RColorBrewer)
display.brewer.all()

#ColorBrewer调色板可以通过名称来选择，比如，使用橘黄色调色板
p + scale_fill_brewer(palette = "Oranges")

#使用灰度调色板，标度范围是0~1（其中0对应黑色，1对应白色）。
#灰度调色板的默认范围是0.2~0.8（可以改）
p + scale_fill_grey()
#倒转方向并且更改灰度范围
p + scale_fill_grey(start = 0.7, end = 0)

#=========================================================================================
#对离散型变量使用自定义调色板
#=========================================================================================
#将用scale_colour_manual()函数自定义颜色。
#其中颜色可以是已命名的，也可以使RGB形式
library(gcookbook) #为了使用数据集

#基本图形
h <- ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=sex)) + geom_point()
#使用颜色名
h + scale_color_manual(values = c("red", "blue"))
#使用RGB值
h + scale_color_manual(values = c("#CC6666", "#7777DD"))
#参数value向量中的元素顺序自动匹配离散标度对应银子水平的顺序。

#如果变量是字符型向量而非因子形式，那么它会被自动转化为因子，顺序也默认地按字母表排序
h + scale_color_manual(values = c(m="blue", f="red"))

#=========================================================================================
#使用色盲友好式的调色板
#=========================================================================================
#使用scale_fill_manual(), 调色板cb_palette用自定义的
library(gcookbook) #为了使用数据
#基础图形
p <- ggplot(uspopage, aes(x=Year, y=Thousands, fill=AgeGroup)) + 
  geom_area()
#加入灰色到调色板
cb_palette <- c("#999999", "#E69F00", "#56B4E9", "#009E73",
                "#F0E442","#0072B2", "#D55E00", "#CC79A7")

#将其使用到图形中
p + scale_fill_manual(values = cb_palette)
#=========================================================================================
#对连续型变量使用自定义调色板
#=========================================================================================
library(gcookbook) #为了使用数据集

#基础图形
p <- ggplot(heightweight, aes(x=ageYear, y=heightIn, color=weightLb)) +
  geom_point(size=3)
p
#使用两种颜色的渐变色(两色渐变)
p + scale_colour_gradient(low="black", high = "white")

#渐变色中间用白色划分（三色渐变）
library(scales)
p + scale_colour_gradient2(low = muted("red"),
                           mid="white",
                           high = muted("blue"))
#n个颜色的渐变色（等间隔的n种颜色渐变色）
p + scale_color_gradientn(colours = c("darkred", "orange", "yellow", "white"))


#=========================================================================================
#根据数值设定阴影颜色
#=========================================================================================
#增加一列来对y进行划分，然后将该列映射到填充色标度上。在本例中，首先对数据进行正负划分。
library(gcookbook) #为了使用数据集
cb <- subset(climate, Source == "Berkeley")
cb$valence[cb$Anomaly10y >=0 ] <- "pos"
cb$valence[cb$Anomaly10y < 0 ] <- "neg"
cb

#对数据划分正负之后，我们就可以将valence变量映射到填充色上来作图
ggplot(cb, aes(x=Year, y=Anomaly10y)) + 
  geom_area(aes(fill=valence)) +
  geom_line() +
  geom_hline(yintercept = 0)


#在0水平线附近有一些凌乱的阴影，这是因为两个颜色区域都是由各自的数据点多边形包围形成的，而这些数据点并不都在0上。
#为了解决这个问题，我们可以用approx()将数据插值到1000个点左右。
#approx() 返回一个列表，包含x和y向量
interp <- approx(cb$Year, cb$Anomaly10y, n=1000)

#放在一个数据框中并重新计算valence
cbi <- data.frame(Year=interp$x, Anomaly10y=interp$y)
cbi$valence[cbi$Anomaly10y >= 0] <- "pos"
cbi$valence[cbi$Anomaly10y < 0 ] <- "neg"

#重新绘制插值后的数据，并做调整：让阴影区域半透明、改变颜色、移除图例并删除填充区域左右两侧的空余
ggplot(cbi, aes(x=Year, y=Anomaly10y)) +
  geom_area(aes(fill=valence), alpha = 0.4) + 
  geom_line() +
  geom_hline(yintercept = 0) +
  scale_fill_manual(values = c("#CCEEFF", "#FFDDDD"), guide=FALSE) +
  scale_x_continuous(expand = c(0,0))
