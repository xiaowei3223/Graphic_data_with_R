#=========================================================================================
#移除图例
#=========================================================================================
#使用guides()，并指定需要移除图例的标度
#基本图形（含图例）
p <- ggplot(PlantGrowth, aes(x=group, y=weight, fill=group)) + geom_boxplot()
p
#移除标度fill的图例
p + guides(fill=FALSE)
p + scale_fill_discrete(guide=FALSE)
p + theme(legend.position = "none") #会移除所有的图例

#=========================================================================================
#修改图例的位置
#=========================================================================================
#图例的默认位置处于右侧
#使用theme(legend.positon=...)即可。
#通过参数top、left、right或bottom，图例即可被放置在顶部、左侧、右侧或底部
p <- ggplot(PlantGrowth, aes(x=group, y=weight, fill=group)) + geom_boxplot()+
  scale_fill_brewer(palette = "Pastel2")
p + theme(legend.position = "top")

#使用legend.justification来指定图例框的哪一部分被放置到legend.positon所指定的位置上。
p + theme(legend.position=c(1,0), legend.justification = c(1,0))#右下角
p + theme(legend.position=c(1,1), legend.justification = c(1,1))#右上角

#在绘图区域内放置图例时，添加一个不透明的边界使其与图形分开可能会有所帮助
p + theme(legend.position = c(0.85, 0.2)) +
  theme(legend.background = element_rect(fill = "white", colour = "black"))
#移除图例元素周围的边界以使其融入图形
p + theme(legend.position = c(0.85, 0.2)) +
  theme(legend.background = element_blank()) + #移除整体的边框
  theme(legend.key = element_blank()) @移除每个图例项目周围的边框



#=========================================================================================
#修改图例项目的顺序
#=========================================================================================
#将对应标度的参数limits设置为理想的顺序即可

#基本图形
p <- ggplot(PlantGrowth, aes(x=group, y=weight, fill=group)) + geom_boxplot()
p
#修改项目顺序
p + scale_fill_discrete(limits=c("trt1", "trt2", "ctr1"))

e

#=========================================================================================
#反转图例项目的顺序
#=========================================================================================
#添加guides(fill=guide_legend(reverse=TRUE))以反转图例的顺序
#基本图形
p <- ggplot(PlantGrowth, aes(x=group, y=weight, fill=group)) + geom_boxplot()
p
#反转图例顺序
p + guides(fill = guide_legend(reverse = TRUE))

#在设定标度的同时也可以控制图例，如下所示：
p + scale_fill_hue(guide = guide_legend(reverse = TRUE))

#=========================================================================================
#修改图例标题
#=========================================================================================
#使用labs()并设定fill、colour、shape或任何对于图例来说合适的图形属性的值
#基本图形
p <- ggplot(PlantGrowth, aes(x=group, y=weight, fill=group)) + geom_boxplot()
p
#设置图例标题为 "condition"
p + labs(fill="Condition")
#或
p + scale_fill_discrete(name="Condition")

#如果有多个变量被映射到带有图例的图形属性（即除x和y意外的图形属性），可以分布设置每个图例的标题。
library(gcookbook) #为了使用数据集
#绘制基本图形
hw <- ggplot(heightweight, aes(x=ageYear, y=heightIn, colour=sex)) +
  geom_point(aes(size=weightLb)) + scale_size_continuous(range = c(1,4))
hw
#使用新的图例标题
hw + labs(colour="Male/Female", size="Weight\n(pounds)")

#如果有一个变量被分别映射到两个图形属性，则默认会生成一个组合了两种情况的图例。
#例如：把sex同时映射到shape和weight上，将指挥出现一个图例
hw1 <- ggplot(heightweight, aes(x=ageYear, y=heightIn, shape=sex, colour=sex)) + geom_point()
hw1
#此时，要修改图例标题时，需要同时设置二者的标题
#如果只修改其中一个，则会得到两个分离的图例

#仅修改shape的标题
hw1 + labs(shape="Male/Female")
#同时修改shape和colour的标题
hw1 + labs(shape="Male/Female", colour="Male/Female")

#=========================================================================================
#修改图例标题的外观
#=========================================================================================
#使用theme(legend.title=element_text())
p <- ggplot(PlantGrowth, aes(x=group, y=weight, fill=group)) + geom_boxplot()
p + theme(legend.title = element_text(face="italic", family = "Times", colour = "red", size = 14))

#也可以通过guides()来指定图例标题的外观，但这种方式有点啰嗦
p + guides(fill=guide_legend(title.theme = element_text(face="italic", family = "times", colour = "red", size = 14)))
#=========================================================================================
#移除图例标题
#=========================================================================================
#添加语句guides(fill=guide_legend(title=NULL))可以重图例中移除标题
ggplot(PlantGrowth, aes(x=group, y=weight, fill=group)) + geom_boxplot() + 
  guides(fill=guide_legend(title = NULL))

#=========================================================================================
#修改图例标签
#=========================================================================================
#设置标度中的labels参数
library(gcookbook) #为了使用数据集

#基本图形
p <- ggplot(PlantGrowth, aes(x=group, y=weight, fill=group)) + geom_boxplot()
#修改图例标签
p + scale_fill_discrete(labels=c('Control', "Treatment 1", "Treatment 2"))

p + scale_fill_grey(start = 0.5, end = 1,
                    labels=c('Control', "Treatment 1", "Treatment 2"))

#同时修改图例项目的顺序，并确保以相同的顺序设置标签
p + scale_fill_discrete(limits=c("trt1", "trt2", "ctr1"),
                        labels=c("Treatment 1", "Treatment 2", "Control"))

#如果有一个变量被分别映射到两个图形属性，则默认会生成一个组合了两种情况的图例。
#如果希望修改图例标签，则必须同时修改两种标度中的标签，否则将得到两个分离的图例

#基本图形
p <- ggplot(heightweight,aes(x=ageYear, y=heightIn, shape=sex, colour=sex)) + geom_point()
p
#修改一个标度中的标签
p + scale_shape_discrete(labels=c("Female", "Male"))
#同时修改两个标度中的标签
p + scale_shape_discrete(labels=c("Female", "Male")) +
  scale_colour_discrete(labels=c("Female", "Male"))
#=========================================================================================
#修改图例标签的外观
#=========================================================================================
#使用theme(legend.text=element_text())

#基本图形
p <- ggplot(PlantGrowth, aes(x=group, y=weight, fill=group)) + geom_boxplot()
p
#修改图例标签的外观
p + theme(legend.text = element_text(face="italic", family = "Times", colour = "red", size = 14))
#也可以通过guides()来指定图例标签的外观
#修改fill对应图例标签文本的外观
p + guides(fill=guide_legend(label.theme = 
                               element_text(face="italic", family = "Times", colour = "red", size = 14)))




#=========================================================================================
#使用含多行文本的标签
#=========================================================================================
#在相应标度中设置labels参数，使用\n来表示新行

#本例中使用scale_fill_discrete()来控制标度fill的图例
p <- ggplot(PlantGrowth,aes(x=group, y=weight, fill=group)) + geom_boxplot()
#含有多于一行文本的标签
p + scale_fill_discrete(labels=c("Control", "Type 1\ntreatment", "Type 2\ntreatment"))

#默认设置下，当使用多余一行文本的标签时，各行文本将相互叠加。
#要处理这个问题，可以使用theme()增加图例说明的高度并减小隔行的间距完成。
#要实现这个操作，需要使用grid包中的unit()函数来指定高度
library(grid)
p + scale_fill_discrete(labels=c("Control", "Type 1\ntreatment", "Type 2\ntreatment")) +
  theme(legend.text = element_text(lineheight = 0.8),
        legend.key.height = unit(1, "cm"))
