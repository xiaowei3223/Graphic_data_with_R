#===============================================================
#绘制简单条形图
#===============================================================
library(ggplot2)
library(gcookbook)
ggplot(pg_mean, aes(x=group, y=weight)) + geom_bar(stat = "identity")

#当x是连续型（数值型）变量是，条形图的结果与上图会略有不同。
#没有Time == 6的输入
BOD
#Time是数值型（连续型）变量
str(BOD)
ggplot(BOD, aes(x = Time, y = demand)) + geom_bar(stat = "identity")
#使用factor()函数将Time转化为离散型（分类）变量
ggplot(BOD, aes(x = factor(Time), y = demand)) + geom_bar(stat = "identity")

#默认设置下，条形图的填充色为黑灰色且条形图没有边框线，
#可以通过调整fill参数的值来改变条形图的填充色
#可通过colour参数为条形图添加边框线
ggplot(pg_mean, aes(x=group, y=weight)) + 
  geom_bar(stat = "identity", fill = "lightblue", colour = "black")
#在ggplot2中，颜色参数默认使用的是影视拼写colour，而非没事拼写color

#===================================================================
#绘制簇状条形图
#===================================================================
#将分类变量映射到fill参数，运行命令geom_bar(position="dodge")
library(gcookbook)
cabbage_exp
ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(position = "dodge", stat = "identity")
#可以通过将geom_bar()中的参数指定为colour=“black"为条形添加黑色边框线；
#可以通过scale_fill_brewer()或者scale_fill_manual()函数对图形颜色进行设置
#此例子使用RColorBrewer包中的Pastell调色盘对图形进行调色
library(RColorBrewer)
ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(position = "dodge", stat = "identity",colour = "black") +
  scale_fill_brewer(palette = "Pastell")

#如果分类变量各水平的组合中有确实像，绘图结果中的条形则相应地略去不绘，
#临近的条形将自动扩充带相应位置
#山区上例数据中的最后一行
ce <- cabbage_exp[1:5,] #复制删除最后一行的数据集
ce
ggplot(ce, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(position = "dodge", stat = "identity",colour = "black") +
  scale_fill_brewer(palette = "Pastell")

#如果数据与上面类似，可以在分类变量组合缺失的哪一项为变量y手动输入一个NA值

#===============================================================
#绘制频数条形图
#===============================================================
ggplot(diamonds, aes(x=cut)) + geom_bar()#这等价于使用geom_bar(stat = "bin")
#geom_bar()默认下将参数设定为stat = "bin"，
#该操作会自动计算每组（根据x轴上的变量进行分组）变量对应的观测数
ggplot(diamonds,aes(x=carat)) + geom_bar()#当x轴对应于连续型变量，结果是一张直方图

#===============================================================
#条形图着色
#===============================================================
#将合适的变量映射到填充色fill上即可。
library(gcookbook)
upc <- subset(uspopchange, rank(Change) > 40)
upc
#将region映射到fill并绘制条形图
ggplot(upc, aes(x = Abb, y = Change, fill = Region)) +
  geom_bar(stat = "identity")
#条形图默认颜色不太吸引眼球，
#用函数scale_fill_brewer()或scale_fill_manua()重新设定图形颜色
#颜色的映射设定是在aes()内部完成的
#颜色的重新设定是在aes()外部完成的
#reorder()将因子根据另一个变量重新水平排序
ggplot(upc, aes(x = reorder(Abb, Change), y = Change, fill = Region)) +
  geom_bar(stat = "identity", colour = "black") +
  scale_fill_manual(values = c("#669933", "#FFCC66")) +
  xlab("State")

#=================================================================
#对正负条形图分别着色
#=================================================================
#创建一个对取值正负情况进行标示的变量pos
library(gcookbook)
csub <- subset(climate, Source == "Berkeley" & Year >= 1900)
csub$pos <- csub$Anomaly10y >= 0 #TRUE or FALSE
csub
#将pos映射给填充色参数fill
#条形图参数postion = "identity",避免系统因对负值绘制堆积条形而发出警告信息
ggplot(csub, aes(x= Year, y = Anomaly10y, fill = pos)) +
  geom_bar(stat = "identity", position = "identity")
#可以通过scale_fill_manual()对图形颜色进行调整，设定参数guide = FALSE可以删除图例
#设定边框颜色colour和边框线宽度size为图形添加一个细黑色边框
ggplot(csub, aes(x= Year, y = Anomaly10y, fill = pos)) +
  geom_bar(stat = "identity", position = "identity", colour = "black", size=0.25) +
  scale_fill_manual(values = c("#CCEEFF", "#FFDDDD"), guide = FALSE)
#=================================================================
#调整条形宽度和条形间距
#=================================================================
#通过设定geom_bar()参数width可以使条形变宽或窄，默认值是0.9
library(gcookbook)
ggplot(pg_mean, aes(x=group, y=weight)) + geom_bar(stat = "identity")
ggplot(pg_mean, aes(x=group, y=weight)) + geom_bar(stat = "identity", width = 0.5)
ggplot(pg_mean, aes(x=group, y=weight)) + geom_bar(stat = "identity", width = 2)

#簇状条形图默认组内的条形间距为0.
#增加组内条形得间距，通过width设定得小一些，position_dodge取值大于width

#更窄得簇状条形图
ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(position = "dodge", stat = "identity", width = 0.5)
#调价条形组距
ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(position = position_dodge(0.7), stat = "identity", width = 0.5)
#position = "dodge"是position = position_dodge(0.9)的简写

#=======================================================================
#绘制堆积条形图
#=======================================================================
#使用geom_bar()，并映射一个变量给fill即可。
library(gcookbook)
ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(stat = "identity")

#默认绘制的条形图中，条形的堆积顺序与图例顺序是相反的。
#可以通过guides()对图例顺序进行调整，并指定图例所对应的需要调整的图形属性
ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(stat = "identity") +
  guides(fill = guide_legend(reverse = TRUE))

#调整过条形的堆叠顺序，通过参数order=desc()来实现
library(plyr) #为了使用desc()函数
ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar, order = desc(Cultivar))) +
  geom_bar(stat = "identity")

#使用scale_fill_brewer()得到一个新的调色板
#设定colour = "black"为条形添加一个黑色边框线
ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(stat = "identity",colour = "black") +
  guides(fill = guide_legend(reverse = TRUE)) +
  scale_fill_brewer(palette = "Pastell")

#=======================================================================
#绘制百分比堆积条形图
#=======================================================================
#通过plyr包中的ddply()函数和transform()函数将每组条形对应的数据标准化为100%形式。
#之后针对绘制的结果绘制百分比堆积条形图
library(gcookbook)
library(plyr)
#以Date为切割变量对每组数据进行transfor()
ce <- ddply(cabbage_exp, "Date", transform,
            percent_weight = Weight/sum(Weight)*100)

library(ggplot2)
ggplot(ce, aes(x = Date, y = percent_weight, fill = Cultivar)) +
  geom_bar(stat = "identity")

#-调色
ggplot(ce, aes(x = Date, y = percent_weight, fill = Cultivar)) +
  geom_bar(stat = "identity", colour = "black") +
  guides(fill = guide_legend(reverse = TRUE)) +
  scale_fill_brewer(palette = "Pastell")

#=====================================================================
#添加数据标签
#=====================================================================
#在绘图命令中加上geom_text()即可为条形图添加数据标签。
#需要分别指定一个变量映射给x、y和标签本身。
#通过设定vjust（竖直调整数据标签位置）可以将标签位置移动至条形图顶端的上方或下方。
library(gcookbook) #为了使用数据
#在条形图顶端下方
ggplot(cabbage_exp, aes(x = interaction(Date, Cultivar), y = Weight)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=Weight), vjust = 1.5, colour = "white")

#在条形图顶端上方
ggplot(cabbage_exp, aes(x = interaction(Date, Cultivar), y = Weight)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=Weight), vjust = -0.2)

#有时数据标签溢出绘图区域-----
#可以通过设定y轴的范围，
#也可以设定数据标签的y轴坐标高于条形图顶端。

#将y轴上限变大
ggplot(cabbage_exp, aes(x = interaction(Date, Cultivar), y = Weight)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=Weight), vjust = -0.2) +
  ylim(0, max(cabbage_exp$Weight) *1.05)
#设定标签的y轴位置使其略高于条形图顶端——y轴范围会自动调整
ggplot(cabbage_exp, aes(x = interaction(Date, Cultivar), y = Weight)) +
  geom_bar(stat = "identity") +
  geom_text(aes(y = Weight + 0.1, label=Weight))  

#对于簇状条形图，需要设定position=position_dodge()并给其一个参数来设定分类间距。分类间距默认值是0.9
#因为簇状条形图的条形更窄，所以需要使用字号（size）来缩小数据标签的字体大小以匹配条形宽度
#数据标签的默认字号是5
#此处设定数据标签为3
ggplot(cabbage_exp, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(stat = "identity", position = "dodge") +
  geom_text(aes(label=Weight), vjust = 1.5, colour = "white", 
            position = position_dodge(0.9), size = 3 )  


#对于堆积条形图添加数据标签时，先要对每组条形对应的数据进行累计求和。
#首先，需保证数据的合理排序
#可以使用plyr包中的arrange()函数完成数据的合理排序
library(plyr)
#根据日期和性别对数据进行排序
ce <- arrange(cabbage_exp, Date, Cultivar)
#确认数据合理排序后，借助ddply()函数以Date为分组变量对数据进行分组，
#并分别计算每组数据对应的变量Weight的累积和
#计算累积和
ce <- ddply(ce, "Date", transform, label_y = cumsum(Weight))
ce

ggplot(ce, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(stat = "identity") +
  geom_text(aes(y = label_y, label=Weight), vjust = 1.5, colour = "white")

#如果需要把数据标签置于条形中部
#须对累计求和的结果加以调整，
#并同时略去geom_bar()函数中对y偏移量（offset)的设置
ce <- arrange(cabbage_exp, Date, Cultivar)
#计算y轴的位置，将数据标签置于条形中部
ce <- ddply(ce, "Date", transform, label_y = cumsum(Weight)-0.5*Weight)
ggplot(ce, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(stat = "identity") +
  geom_text(aes(y = label_y, label=Weight),colour = "white")

#修改图例顺序和颜色，将数据标签置于条形中间，缩小标签字号
ggplot(ce, aes(x = Date, y = Weight, fill = Cultivar)) +
  geom_bar(stat = "identity", colour = "black") +
  geom_text(aes(y = label_y, label=paste(format(Weight, nsmall = 2), "kg")),
            size = 4) +
  guides(fill = guide_legend(reverse = TRUE)) +
  scale_fill_brewer(palette = "Pastell")

#====================================================================
#绘制Cleveland点图
#====================================================================
#使用Cleveland点图来替代条形图可以减少图形造成的视觉混乱并使图形更具有可读性

library(gcookbook) #为了使用数据
tophit <- tophitters2001[1:25,]
ggplot(tophit, aes(x=avg, y=name)) + geom_point()

#根据avg对name进行排序
#reorder()只能根据一个变量对因子水平进行排序
ggplot(tophit, aes(x=avg, y=reorder(name,avg))) + 
  geom_point(size = 3) + #使用更大的点
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(colour = "grey60", linetype = "dashed"))

#将x、y轴互换,并将数据标签旋转60度
ggplot(tophit, aes(y=avg, x=reorder(name,avg))) + 
  geom_point(size = 3) + #使用更大的点
  theme_bw() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1),
    panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.x = element_line(colour = "grey60", linetype = "dashed"))

#提取出names变量，一次根据变量lg和avg对其进行排序
nameorder <- tophit$name[order(tophit$lg, tophit$avg)]

#将name转化为因子，因子水平与nameorder一致
tophit$name <- factor(tophit$name, levels = nameorder)

#绘制点图时，把lg变量映射到点的颜色属性上。
#借助geom_segment()函数用“以数据点位端点的线段：代替贯通全图的网格线
#geom_segment()函数需要设定x、y、xend和yend四个参数
ggplot(tophit, aes(x=avg, y=name)) +
  geom_segment(aes(yend=name),xend=0, colour="grey50") +
  geom_point(size=3, aes(colour=lg)) +
  scale_color_brewer(palette = "Set1",limits=c("NL","AL")) +
  theme_bw() +
  theme(panel.grid.major.y = element_blank(), #删除水平网格线
        legend.position = c(1, 0.55), #将图例防止在绘图区域
        legend.justification = c(1, 0.5))

#分面条形图
ggplot(tophit, aes(x=avg, y=name)) +
  geom_segment(aes(yend=name),xend=0, colour="grey50") +
  geom_point(size=3, aes(colour=lg)) +
  scale_color_brewer(palette = "Set1",limits=c("NL","AL"), guide = FALSE) +
  theme_bw() +
  theme(panel.grid.major.y = element_blank()) + #删除水平网格线
  facet_grid(lg ~ ., scales = "free_y", space = "free_y")
        
