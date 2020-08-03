
#========================================================================
#设置图形标题
#========================================================================
#使用ggtitle()设置图形标题
library(gcookbook) #为了使用标题
p <- ggplot(heightweight, aes(x=ageYear,y=heightIn)) + geom_point()
p + ggtitle("Age and Height of Schoolchildren")
#使用\n来换行
p + ggtitle("Age and Height\nof Schoolchildren")

#使用ggtitle()与使用labs(title="标题文本")是等价的。
#将标题移动到绘图区域内部：
#第一种方式是将一个负的vjust值与ggtitle()配合使用。
#移动标题到内部
p + ggtitle("Age and Height of Schoolchildren") +
  theme(plot.title = element_text(vjust = -5.5))
#或使用一个文本型注解
p + annotate("text", x=mean(range(heightweight$ageYear)), y=Inf, 
             label="Age and Height of Schoolchildren", vjust=1.5, size=6)

#========================================================================
#修改文本外观
#========================================================================
#修改图形中文本的外观
#设置如标题、坐标轴标签和坐标轴刻度线等主题项目的外观，使用theme()并通过element_text()设定对应项目的属性即可。
#举例来说： axis.title.x控制着x轴标签的外观，plot.title控制着标题文本的外观
library(gcookbook) #为了使用数据集
#基本图形
p <- ggplot(heightweight, aes(x=ageYear,y=heightIn)) + geom_point()
#主题项目外观的控制
p + theme(axis.title.x = element_text(size=16, lineheight = 0.9, family = "Times",
                                      face = "bold.italic", colour = "red"))
p + ggtitle("Age and Height of Schoolchildren") + 
  theme(plot.title = element_text(size = rel(1.5),lineheight = 0.9, 
                                  family = "Times", face="bold.italic", colour = "red"))
#rel(1.5)表示字体大小将为当前主题基准字体大小的1.5倍

#要设置文本几何对象（即在图形内部使用geom_text()或annotate()添加的文本）的外观，
#只需设置其文本属性即可。
p + annotate("text", x=15, y=53, label="Some text", size=7, family="Times",
             fontface="bold.italic", colour="red")
#在ggplot2中，文本项目分为两类：
#主题元素：包括所有非数据元素：如标题、图例和坐标轴
#文本几何对象：属于图形本身的一部分


#========================================================================
#使用主题
#========================================================================
#使用与之的主题，向图形添加theme_bw()或theme_grey()即可。
library(gcookbook) #为了使用数据集
#基本图形
p <- ggplot(heightweight, aes(x=ageYear, y=heightIn)) + geom_point()
#默认灰色主题
p + theme_gray()
#黑白主题
p + theme_bw()

#ggplot2中主题元素的某些常用属性是通过theme()来控制的。 
#其中多数属性，如标题、图例和坐标轴，位于绘图区域的外部，但另一些则位于绘图区域的内部，如网格线和背景色

#自行设置两个内置主题的基本字体和字体大小（默认的基本字体为无衬线的Helvetica，默认大小为12）
p + theme_gray(base_size = 16, base_family = "Times")

#也可以使用theme_set()设置当前R绘画下的默认主题：
#为当前会话设置默认主题
theme_set(theme_bw())
#将使用theme_bw()
p
#将默认主题重置回theme_gray()
theme_set(theme_gray())

#========================================================================
#修改主题元素的外观
#========================================================================
#要修改一套主题，配合相应的element_xx对象添加theme()函数即可。
#element_xx对象包括element_line\element_rect和element_text.

library(gcookbook)
#基本图形
p <- ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=sex)) + geom_point()
#绘图区域的选项
p + theme(
  panel.grid.major = element_line(colour = "red"),
  panel.grid.minor = element_line(colour = "red", linetype = "dashed", size = 0.2),
  panel.background = element_rect(fill = "lightblue"),
  panel.border = element_rect(colour = "blue", fill = NA, size = 2)
)
#文本项目的选项
p + ggtitle("Plot title here") +
  theme(
    axis.title.x = element_text(colour = "red", size = 14),
    axis.text.x = element_text(colour = "blue"),
    axis.title.y = element_text(colour = "red", size = 14, angle = 90),
    axis.text.y = element_text(colour = "blue"),
    plot.title = element_text(colour = "red", size = 20, face = "bold")
  )
#图例选项
p + theme(
  legend.background = element_rect(fill = "grey85", colour = "red", size = 1),
  legend.title = element_text(colour = "blue", face = "bold", size = 14),
  legend.text = element_text(colour = "red"),
  legend.key = element_rect(colour = "blue", size = 0.25)
)

#分面选项
p + facet_grid(sex~.) +theme(
  strip.background = element_rect(fill="pink"),
  strip.text.y = element_text(size = 14, angle = -90, face = "bold")
)

#使用一套现成的主题并使用theme()，微调其中的一部分：
#如果在添加一套完整的主题之前使用，theme()将没有效果
p + theme(axis.title.x = element_text(colour = "red")) + theme_bw()
#在完整的主题后使用，theme()可以正常工作
p + theme_bw() +theme(axis.title.x = element_text(colour = "red", size = 17))

#========================================================================
#创建自定义主题
#========================================================================
#通过向一套线程主题添加元素的方式创建自定义主题
library(gcookbook) #为了使用数据集
#从theme_bw()入手，修改了一些细节
mytheme <- theme_bw() +
  theme(text = element_text(colour = "red"),
        axis.title = element_text(size = rel(1.25)))

#基本图形
p <- ggplot(heightweight, aes(x=ageYear, y=heightIn)) + geom_point()
#使用修改后的主题绘图
p + mytheme
#========================================================================
#隐藏网格线
#========================================================================
#主网格线（与刻度线对齐的那些）可通过panel.grid.major来控制，
#次网格线之间的那些）则通过panel.grid.minor来控制。
library(gcookbook) #为了使用数据集
p <- ggplot(heightweight, aes(x=ageYear, y=heightIn)) + geom_point()
p + theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank())

#也可以通过使用panel.grid.major.x、panel.grid.major.y、panel.grid.minor.y,
#我们也可以只隐藏纵向或横向网格线

#隐藏纵向网格线（与x轴交汇的那些）
p + theme(panel.grid.major.x = element_blank(),
          panel.grid.minor.x = element_blank())
#隐藏横向网格线（与y轴交汇的那些）
p + theme(panel.grid.major.y = element_blank(),
          panel.grid.minor.y = element_blank())
