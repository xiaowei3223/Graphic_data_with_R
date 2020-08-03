#=========================================================================================
#使用分面将数据分割绘制到子图中
#=========================================================================================
#使用facet_grid()或facet_wrap()函数，并指定根据哪个变量来分割数据。

#使用facet_grid()函数时， 可以指定一个变量作为纵向子面板分割的依据，
#并指定另外一个变量作为横向子面板分割的依据

#基本图形
p <- ggplot(mpg, aes(x=displ,y=hwy)) + geom_point()

#纵向排列的子面板根据drv分面
p + facet_grid(drv ~ .)

#横向排列根据cyl分面
p + facet_grid(. ~cyl)

#同时根据drv（纵向）喝cyl（横向）分割 
p + facet_grid(drv ~ cyl)

#使用facet_wrap()时，各子图将像纸上的文字一样被依次横向排布并换行
#依class分面
#注意波浪线前没有任何字符
p + facet_wrap( ~class)

#要对该方阵进行修改，可以通过像nrow或ncol赋值实现
#两种方式的结果是相同的， 2行4列
p + facet_wrap(~class, nrow = 2)
p + facet_wrap(~class, ncol = 4)


#=========================================================================================
#在不同坐标轴下使用分面
#=========================================================================================
#将标度设置为"free_x"、"free_y"或"free"

#基本图形
p <- ggplot(mpg, aes(x=displ, y=hwy)) + geom_point()
#使用自由的y标度
p + facet_grid(drv ~ cyl, scales = "free_y")
#使用自由的x标度喝y标度
p + facet_grid(drv ~cyl, scales = "free")

#=========================================================================================
#修改分面的文本标签
#=========================================================================================
#修改因子各水平的名称即可

mpg2 <- mpg #复制一份原始数据
#重命名4为4wd、f为Front、r为Rear
mpg2$drv[mpg2$drv == "4"] <- "4wd" 
mpg2$drv[mpg2$drv == "f"] <- "Front"
mpg2$drv[mpg2$drv == "r"] <- "Rear"
#绘制新数据
ggplot(mpg2, aes(x=displ, y=hwy)) + geom_point() + facet_grid(drv~.)

#另一个使用贴标函数是label_prased()，可以读入字符串，并将其作为R数学表达式来解析
mpg3 <- mpg
mpg3$drv[mpg3$drv == "4"] <- "4^{wd}" 
mpg3$drv[mpg3$drv == "f"] <- "- Front %.% e^{pi*i}"
mpg3$drv[mpg3$drv == "r"] <- "4^{wd} - Front"
ggplot(mpg3, aes(x=displ, y=hwy)) + geom_point() + facet_grid(drv ~., labeller = label_parsed)

#=========================================================================================
#修改分面标签和标题的外观
#=========================================================================================
#使用主题系统，通过设置strip.text来控制文本的外观，设置strip.backgroup以控制背景的外观
library(gcookbook) #为了使用数据集
ggplot(cabbage_exp, aes(x=Cultivar, y=Weight)) + geom_bar(stat="identity") +
  facet_grid(. ~ Date) +
  theme(strip.text = element_text(face = "bold", size = rel(1.5)), 
        strip.background = element_rect(fill = "lightblue", colour = "black", size = 1))

