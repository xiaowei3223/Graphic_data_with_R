
#=========================================================================================
#绘制相关矩阵图
#=========================================================================================
#使用cor函数来计算相关矩阵，将会得到每两列之间的相关系数
mtcars 
mcor <- cor(mtcars)
#输出mcor，保留两位小鼠
round(mcor, digits = 2)

#如果数据含有不能用来计算系数的任何列，应该先将这些列剔除。
#如果在原始数据中存在缺失值（NA），得到的相关矩阵中也会缺失值。
#为了克服这个问题，可以使用函数选项use="complete.obs"或者use="pairwise.complete.obs"
#使用corrplot包来绘制相关矩阵图
library(corrplot)
corrplot(mcor)

#corrplot()函数有相当多的选项，这里给出一个绘制相关矩阵图的例子，例图使用颜色方块和黑色文本标签，
#并且上边的文本标签呈45°右倾。
corrplot(mcor, method = "shade", shade.col = NA, tl.col = "black", tl.srt = 45)

#移除掉多余的颜色图例
#生成一个淡一点的调色板
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))

# corrplot(mcor, method = "shade", shade.col = NA, tl.col = "black", tl.srt = 45,
#          col = col(200), addCoef.col = "black", cl.pos = "no", order = "AOE")



#=========================================================================================
#绘制函数曲线
#=========================================================================================
#使用stat_function()函数，为了得到合适的x的范围，必须给ggplot()函数传递给一个“哑”数据框
#这个数据框仅仅用于设定范围
#用正态分布的密度函数dnorm()来演示
p <- ggplot(data.frame(x=c(-3,3)), aes(x=x))
p + stat_function(fun = dnorm)

#某些函数需要设定额外的参数，比如t分布的密度函数dt()就需要一个参数来设定自由度，
#可以这样来设定额外的参数：先把它们放在一个列表（list）中，再传递给args
p + stat_function(fun=dt, args = list(df=2))

#也可以绘制自定义的函数，其中第一个参数必须是x轴的值，并且必须返回y轴的值。
myfun <- function(xvar){
  1/(1 + exp(-xvar + 10))
}

ggplot(data.frame(x=c(0,20)), aes(x=x)) + stat_function(fun = myfun)

#=========================================================================================
#在函数曲线下添加阴影
#=========================================================================================

#在0 <x < 2时返回dnorm(x), 其他时候返回NA
dnorm_limit <- function(x){
  y <- dnorm(x)
  y[x<0 | x>2] <- NA
  return(y)
}
#ggplot()使用“哑”数据
p <- ggplot(data.frame(x=c(-3, 3)), aes(x=x))
p + stat_function(fun=dnorm_limit, geom = "area", fill="blue", alpha =0.2) + stat_function(fun = dnorm)

#R中有第一类函数，我们可以写一个函数来返回一个闭包，也就是说，我们可以编写一个能够编写函数的函数

#下面的这个函数将允许你传递一个函数、一个最小值和一个最大值。定义域外对应的值域返回NA
limitRange <- function(fun,min, max){
  function(x){
    y <- fun(x)
    y[x < min | x>max] <- NA
    return(y)
  }
}
#调用这个函数来生成另一个函数
#返回一个函数
dlimit <- limitRange(dnorm, 0, 2)
#现在我们可以尝试新函数了————仅对0-2之间的输入返回输出值
dlimit(-2:4)

#使用limitRange()来生成函数，并传递给stat_function()
p + stat_function(fun=dnorm) +
  stat_function(fun=limitRange(dnorm, 0, 2),
                geom = "area", fill="blue", alpha=0.2)

#limitRange()函数可以用来生成任何函数的“区间限制式”函数，不局限于dnorm()
#=========================================================================================
#绘制网络图
#=========================================================================================
#使用igraph包，要绘制网络图，首先给graph()函数传递一个包含所有边的向量，然后绘制结果对象

library(igraph)
#指定一个有向图的边
gd <- graph(c(1,2, 2,3, 2,4, 1,4, 5,5, 3,6))
plot(gd)

#一个无向图
gu <- graph(c(1,2, 2,3, 2,4, 1,4, 5,5, 3,6))
#不画标签
plot(gu, vertex.label=NA)

#这个两图对象的结构
str(gd)
str(gu)

#可以在绘图之前设置随机数种子，比如：可以尝试不同的随机数种子直到得到一个比较满意的结果
set.seed(229)
plot(gu)

library(gcookbook) #为了使用数据集
madmen2
#从数据集中生成图对象
g <- graph.data.frame(madmen2, directed = TRUE)
#移除多余的空白边
par(mar=c(0,0,0,0))
plot(g, layout=layout.fruchterman.reingold, vertex.size=8, edge.arrow.size=0.5, vertex.label=NA)

#对于无向图来说，方向是没有意义的，使用圆圈布局
g <- graph.data.frame(madmen2, directed = FALSE)
par(mar=c(0,0,0,0)) #移除多余的空白边
plot(g, layout=layout.circle, vertex.size=8,vertex.label=NA)
#=========================================================================================
#在网格图中使用文本标签
#=========================================================================================
#边和节点可能都有名字，但默认时这些名字可能没有被当作标签，为了设置标签，可以给vertex.label参数传递一个命名向量
library(igraph)
library(gcookbook)#为了使用数据集
#复制madmen并删除偶数行
m <- madmen[1:nrow(madmen) %% 2==1, ]
g <- graph.data.frame(m, directed = FALSE)
#输出节点名称
V(g)$name

plot(g,
     layout=layout.fruchterman.reingold,
     vertex.size = 4,   #让节点更小
     vertex.label = V(g)$name, #设置标签
     vertex.label.cex = 0.8, #小号字体
     vertex.label.dist = 0.4,#标签和节点的位置错开
     vertex.label.color ="black")

#另一种能得到相同效果的方法时修改绘图对象。
#这样就不用给plot()函数传递参数值了。
#此时使用V()$xxx <- 来代替vertex.xxx参数传递值

#这和之前的代码是等价的
V(g)$size <- 4
V(g)$label <- V(g)$name
V(g)$label.cex <- 0.8
V(g)$label.dist <- 0.4
V(g)$label.color <- "black"
#设置整个图的属性
g$layout <- layout.fruchterman.reingold
plot(g)

#同样，也可以设置边的属性，使用E()函数或者给edge.xxx参数传递相应的值
#查看边
E(g)
#将几个边的名字赋值为“M"
E(g)[c(2, 11, 19)]$label <- "M"
#将所有边颜色设置为灰色，然后把其中几个变为红色
E(g)$color <- "grey70"
E(g)[c(2, 11, 19)]$color <- "red"

plot(g)
#=========================================================================================
#如何绘制热图
#=========================================================================================
#使用geom_tile()或者geom_raster(),并将一个连续变量映射到fill上。
#我们将使用presidents数据集，它是一个时间序列对象而不是数据框
presidents
str(presidents)
#首先将它转化为ggplot()可用的数据框格式，其中的列都是数值形式的
pre_rating <- data.frame(
  rating = as.numeric(presidents),
  year = as.numeric(floor(time(presidents))),
  quarter = as.numeric(cycle(presidents))
)
pre_rating

#基础图形
p <- ggplot(pre_rating, aes(x=year, y=quarter, fill=rating))
#使用geom_tile()
p + geom_tile()
#使用geom_raster()看起来一样，但效率略高
p + geom_raster()

p + geom_tile() +
  scale_x_continuous(breaks = seq(1940, 1976, by = 4)) +
  scale_y_reverse() +
  scale_fill_gradient2(midpoint = 50, mid = "grey70", limits = c(0,100))

#=========================================================================================
#绘制三维散点图
#=========================================================================================
#使用rgl包，该包提供了OpenGL图形库的3D绘图接口。
#要画三维散点图，可以使用plot3d()函数，其输入参数可以是两种形式：
#（1）一个数据框，前三列分别表示x、y、z的坐标；
#（2）直接传递三个向量，分别表示x、y、z的坐标

library(rgl)
plot3d(mtcars$wt, mtcars$disp, mtcars$mpg, type="s", size=0.75, lit=FALSE)
#读图者可以通过点击和拖动鼠标来旋转图形，滑动鼠标滚轮来缩放图形

#添加数值线段来增强空间点的位置表达力度
#交错出现两个向量的值
interleave <- function(v1,v2) as.vector(rbind(v1, v2))
#绘制点
plot3d(mtcars$wt, mtcars$disp, mtcars$mpg,
       xlab = "weight", ylab = "Displacement", zlab = "MPG",
       size = 0.75, type = "s", lit=FALSE)
#添加线段
segments3d(interleave(mtcars$wt, mtcars$wt),
           interleave(mtcars$disp, mtcars$disp),
           interleave(mtcars$mpg, min(mtcars$mpg)),
           alpha=0.4, col="blue")

#微调图形的背景和坐标轴。
#改变坐标轴刻度的数目、添加刻度值，并在指定的边框添加坐标轴标签
#不画坐标刻度和标签
plot3d(mtcars$wt, mtcars$disp, mtcars$mpg,
       xlab = "", ylab = "", zlab = "",
       axes = FALSE, 
       size = 0.75, type = "s", lit = FALSE)
segments3d(interleave(mtcars$wt, mtcars$wt),
           interleave(mtcars$disp, mtcars$disp),
           interleave(mtcars$mpg, min(mtcars$mpg)),
           alpha=0.4, col="blue")

#绘制盒子
rgl.bbox(color="grey60",  #表面颜色为grey60，黑色文本
         emission ="gray50", #光照颜色为grey50
         xlen = 0, ylen = 0, zlen = 0) #不添加刻度

#设置默认颜色为黑
rgl.material(color = "black")
#在指定边框添加坐标轴标签，可能的值类似于“x--", "x-+", "x+-" 和”x++"
axes3d(edges = c("x--", "y+-", "z--"),
       nticks = 6, #每个轴上6个刻度线
       cex=0.75)   #较小的字体

#添加坐标标签， ‘line'指定标签和坐标轴的距离
mtext3d("Weight", edge = "x--", line = 2)
mtext3d("Displacement", edge = "y+-", line = 2)
mtext3d("MPG", edge = "z--", line = 3)
#=========================================================================================
#在三维图上添加预测曲面
#=========================================================================================
#先定义一些功能函数来得到模型的预测值
#给定一个模型，根据xvar和yvar预测zvar
#默认为变量x和y的范围，生成16*16的网格
predictgrid <- function(model, xvar, yvar, zvar, res = 16, type = NULL){
  #计算预测变量的范围，下面的代码对lm、glm以及其他模型方法都适用，
  #但针对其他模型方法时可能需要适当调整
  xrange <- range(model$model[[xvar]])
  yrange <- range(model$model[[yvar]])
  
  newdata <- expand.grid(x = seq(xrange[1], xrange[2], length.out = res),
                         y = seq(yrange[1], yrange[2], length.out = res))
  names(newdata) <- c(xvar, yvar)
  newdata[[zvar]] <- predict(model, newdata = newdata, type = type)
  newdata
}

#将长数据框中的x,y,z转化为列表
#其中x，y为行列值，z为矩阵
df2mat <- function(p, xvar=NULL, yvar=NULL, zvar=NULL){
  if (is.null(xvar)) xvar <- names(p)[1]
  if (is.null(yvar)) yvar <- names(p)[2]
  if (is.null(zvar)) zvar <- names(p)[3]
  
  x <- unique(p[[xvar]])
  y <- unique(p[[yvar]])
  z <- matrix(p[[zvar]], nrow = length(y), ncol = length(x))
  
  m <- list(x,y,z)
  
  names(m) <- c(xvar, yvar, zvar)
  m
}
#交错出现两个向量的元素
interleave <- function(v1,v2) as.vector(rbind(v1,v2))

#利用这些定义好的功能性函数，我们可以对数据生成线性模型，
#然后利用surface3d()在原散点图上添加网格式的预测图
library(rgl)
#复制数据集
m <- mtcars
#生成线性模型
mod <- lm(mpg ~ wt + disp + wt:disp, data = m)
#根据wt和disp,得到mpg的预测值
m$pred_mpg <- predict(mod)
#根据wt和disp的网格，得到mpg的预测值
mpgrid_df <- predictgrid(mod, "wt", "disp", "mpg")
mpgrid_list <- df2mat(mpgrid_df)
#根据数据点绘图
plot3d(m$wt, m$disp, m$mpg, type = "s", size = 0.5, lit = FALSE)
#添加预测点（较小）
segments3d(interleave(m$wt, m$wt),
           interleave(m$disp, m$disp),
           interleave(m$mpg, m$pred_mpg),
           alpha = 0.4, col="red")

#添加预测点网络
surface3d(mpgrid_list$wt, mpgrid_list$disp, mpgrid_list$mpg,
          alpha = 0.4, front = "lines", back = "lines")

#可以调节图形的外观，也可以逐一添加图形的各个组件
plot3d(mtcars$wt, mtcars$disp, mtcars$mpg,
       xlab = "", ylab = "", zlab = "",
       axes = FALSE,
       size = 0.5, type = "s", lit = FALSE)
#添加预测点（较小）
spheres3d(m$wt, m$disp, m$pred_mpg, alpha=0.4, type=0.5, lit=FALSE)
#添加误差线段
segments3d(interleave(m$wt, m$wt),
           interleave(m$disp, m$disp),
           interleave(m$mpg, m$pred_mpg),
           alpha =0.4, col = "red")
#添加预测值网格
surface3d(mpgrid_list$wt, mpgrid_list$disp, mpgrid_list$mpg,
          alpha=0.4, front="lines", back="lines")
#绘制盒子
rgl.bbox(color = "grey50",#表面颜色为grey60, 黑色文本
         emission = "grey50", #光照颜色为grey50
         xlen = 0, ylen = 0, zlen = 0) #不花刻度线

#对象默认色设置为黑色
rgl.material(color = "black")
#在指定边添加坐标轴标签。可能的值类似于“x--”, "x-+", "x+-" 和“x++"
axes3d(edges = c("x--", "y+-", "z--"),
       nticks = 6, #每个轴上6个刻度线
       cex =0.75) #较小字体
#添加坐标标签，‘line'指定标签和坐标轴的距离
mtext3d("Weight", edge = "x--", line = 2)
mtext3d("Displacement", edge = "y+-", line = 3)
mtext3d("MPG", edge = "z--", line = 3)

#=========================================================================================
#保存三维图
#=========================================================================================
#可以使用rgl.snapshot()来保存rgl包绘制的位图，它会精确捕捉屏幕上的图形
library(rgl)
plot3d(mtcars$wt, mtcars$disp, mtcars$mpg, type="s", size=0.75, lit=FALSE)
rgl.snapshot('3dplot.png', fmt = 'png')

#也可以使用rgl.postscript()保存为PostScript或PDF格式文件
rgl.postscript('figs/miscgraph/3dplot.pdf', fmt = "pdf")
rgl.postscript('figs/miscgraph/3dplot.ps', fmt = "ps")
#PostScript或PDF格式文件并不支持rgl依赖的OpenGL库的很多特性。
#比如，不支持透明度，并且点线等对象的大小可能和屏幕上表现出来的也不一致。

#为了使得输出的图片更加可读， 可以保存当前的视角，之后再恢复

#保存当前视角
view <- par3d("userMatrix")
#恢复保存的视角
par3d(userMatrix = view)


#为了将视角保存为代码，使用dput()， 然后输出复制粘贴到你的代码中
dput(view)

#=========================================================================================
#三维图动画
#=========================================================================================
#旋转三维图能够更完整、多方位地观察数据。

#使用spin3d()中使用spin3d()来生成三维动画
library(rgl)
plot3d(mtcars$wt, mtcars$disp, mtcars$mpg, type="s", size=0.75, lit=FALSE)
play3d(spin3d())

#绕x轴转动，每分钟4转，持续20秒钟
play3d(spin3d(axis=c(1,0,0),rpm = 4), duration = 20)

#绕z轴转动，每分钟4转，持续15秒
movie3d(spin3d(axis = c(0,0,1), rpm = 4), duration = 15, fps = 50)

#=========================================================================================
#绘制谱系图
#=========================================================================================
#使用hclust()并画出它的结果。
library(gcookbook) #为了使用数据集
#得到2009年的数据
c2 <- subset(countries, Year == 2009)
#去掉含有NA的行
c2 <- c2[complete.cases(c2), ]
#随机选择25个国家
#（设定随机种子保证可重复性）
set.seed(201)
c2 <- c2[ssample(1:nrow(c2), 25), ]
c2

#去掉在聚类中不需要的列，这些列是Name、Code和Year
rownames(c2) <- c2$Name
c2 <- c2[,4:7]
c2

#对数据进行标准化
c3 <- scale(c2)
c3
#scale()函数默认是将每一列相对于其标准差进行标准化

hc <- hclust(dist(c3))
#画树状图
plot(hc)
#对齐文本
plot(hc, hang = -1)


#聚类分析是在n维空间中吧点分类到雷的一种简单方法。（在这个例子中是4维）。
#层次聚类分析则将魅族分成两个更小的组，在这里可以用谱系展示。
#在层次聚类的过程中有很多可以控制的参数，可能有不止一种”正确“的方法可以用来分析你的数据。

#hclust()提供了几种做聚类分析的方法，默认的方法是"complete".
#其他可以用的方法包括："ward" "single" "average" "mcquitty" "median"和"centroid" 

#=========================================================================================
#绘制向量场
#=========================================================================================
#使用geom_segment()，每段都有一个起点和一个终点

library(gcookbook) #数据集
isabel
#x和y分别是经度和维度，z是高度，单位是千米。
#Vx、Vy、Vz是风速分量在各个方向的取值，单位是米每秒，speed是风速
islice <- subset(isabel, z==min(z))
ggplot(islice, aes(x=x, y=y)) +
  geom_segment(aes(xend=x +vx/50, yend=y+vy/50), size=0.25) #线段0.25mm粗

#这个向量场有两个问题：数据分辨率太高不容易阅读，而且每段没有箭头表示方向。
#为了降低数据的分辨率，定义一个函数every_n()，在数据的每n个值中保留一个，其他的去掉。

#选择z取值等于z的最小值的部分数据
islice <- subset(isabel, z==min(z))
#向量x中每“by"个值里面保留一个
every_n <- function(x, by=2){
  x <- sort(x)
  x[seq(1, length(x), by = by)]
}

#x和y每四个值保留一个
keepx <- every_n(unique(isabel$x), by=4)
keepy <- every_n(unique(isabel$y), by=4)

#保留那些x值在keepx中并且y值在keepy中的数据
islicesub <- subset(islice, x %in% keepx & y %in% keepy)

library(grid) #为了使用arrow()
#用字迹画图，箭头的长度为0.1cm
ggplot(islicesub, aes(x=x, y=y)) +
  geom_segment(aes(xend = x+vx/50, yend=y+vy/50),
               arrow = arrow(length = unit(0.1, "cm")), size=0.25)

#箭头的一个影响是，短的向量会表现得比它实际长度得比例更大，这回导致曲解数据。
#为了减轻这种影响，把速度映射到其他属性上可能是有用得，如size（线的粗细）、alpha（透明度）或colour（颜色）

#‘speed'列包含z的部分，计算水平速度
islicesub$speedxy <- sqrt(islicesub$vx^2 + islicesub$vy^2)
#映射速度到透明度alpha
ggplot(islicesub, aes(x=x, y=y)) +
  geom_segment(aes(xend=x+vx/50, yend=y+vy/50, alpha=speed),
               arrow = arrow(length = unit(0.1, "cm")), size=0.6)

#下面把速度映射到颜色colour上。
#也加入美国的部分地图并且使用coord_cartesian()放大感兴趣的区域

#得到美国地图数据
usa <- map_data("usa")
#把数据映射到颜色上，颜色从"grey80"到“darkred"
ggplot(islicesub, aes(x=x,y=y)) + 
  geom_segment(aes(xend=x+vx/50, yend=y+vy/50, colour=speed),
               arrow = arrow(length = unit(0.1, "cm")), size=0.6) +
  scale_color_continuous(low="grey80", high="darkred") +
  geom_path(aes(x=long, y=lat, group=group), data=usa) +
  coord_cartesian(xlim = range(islicesub$x), ylim = range(islicesub$y))


#isabel数据集是一个三维数据，可以画一个分面的图形。
#因为每个分面都很小，所以要用比之前更稀疏的子集
#x和y中每5个值保留1个，z中每两个值保留一个
keepx <- every_n(unique(isabel$x), by=5)
keepy <- every_n(unique(isabel$y), by=5)
keepz <- every_n(unique(isabel$z), by=5)

isub <- subset(isabel, x %in% keepx & y %in% keepy & z %in% keepz)
ggplot(isub, aes(x=x,y=y)) + 
  geom_segment(aes(xend=x+vx/50, yend=y+vy/50, colour=speed),
               arrow = arrow(length = unit(0.1, "cm")), size=0.5) +
  scale_color_continuous(low="grey80", high="darkred")+
  facet_wrap( ~z)

#=========================================================================================
#绘制QQ图
#=========================================================================================
llibrary(gcookbook) #为了使用数据集

#height的QQ图
qqnorm(heightweight$heightIn) 
qqline(heightweight$heightIn)

#age的QQ图
qqnorm(heightweight$ageYear)
qqline(heightweight$ageYear)

#heightIn的点很接近理论线，这意味着它的分布很接近正态分布。
#相反，ageYear的点原理理论线，特别时在左面，这表明分布是有偏离的。


#=========================================================================================
#绘制经验累积分布函数图(ECDF)
#=========================================================================================
#使用stat_ecdf()
library(gcookbook) #为了使用数据集

#heightIn的ecdf
ggplot(heightweight, aes(x=heightIn)) + stat_ecdf()
#ageYear的ecdf
ggplot(heightweight, aes(x=ageYear)) + stat_ecdf()

#ECDF表明了在观测数据中，小于或等于给定x值得观测所占得比例。
#因为是经验得，所以累积分布线在每个有一个或者更多观测值得x值处产生一个阶梯。


#=========================================================================================
#绘制马赛克图
#=========================================================================================
#使用vcd包里的mosaic()
UCBAdmissions #这个数据是一个三维的列联表
ftable(UCBAdmissions)#显示“平铺”后的列联表

dimnames(UCBAdmissions) #三个维度分别是Admit、Gender和Dept

#为了可视化这些变量之间的关系，使用mosaic()函数，输入的公式要包含在分割数据中使用的变量

library(vcd)
mosaic(~Admit + Gender + Dept, data=UCBAdmissions) #按照先Admit然后Gender再Dept的顺序分割数据
#注意，mosaic()是按照变量提供的顺序来分割数据的：首先是录取状态，然后是性别，最后是系。
#从图中可以看出，被拒绝的申请者明显比被录取的多。

#另外一个观察数据的方式是按照系别、性别和录取状态的顺序分割数据。
#这时，录取状态是最后一个分离的变量，所以按照系别、性别和录取状态的顺序分割数据，
#录取状态是最后一个分离的变量，所以当按照系别和性别分离数据之后，每组中录取和拒绝的单元正好再彼此的旁边。
mosaic(~Dept + Gender + Admit, data = UCBAdmissions,
       highlighting = "Admit", highlighting_fill=c("lightblue", "pink"),
       direction=c("v", "h", "v"))

#可以使用不同的分割方向
#另一种可能的分割方向
mosaic(~Dept + Gender + Admit, data = UCBAdmissions,
       highlighting = "Admit", highlighting_fill=c("lightblue", "pink"),
       direction=c("v", "v", "h"))

#这个顺序比较男和女不是很容易
mosaic(~Dept + Gender + Admit, data = UCBAdmissions,
       highlighting = "Admit", highlighting_fill=c("lightblue", "pink"),
       direction=c("v", "h", "h"))

#=========================================================================================
#绘制饼图
#=========================================================================================
#使用pie()函数
library(MASS) #为了使用数据集
#得到fold变量每个水平的频数
fold <- table(survey$Fold)
fold
#画饼图
pie(fold)

#我们在pie()中输入table类型的对象，我们也可以提供一个命名的向量，或者一个只有数值的向量和一个标签向量。
pie(c(99, 18,120),labels = c("L on R", "Neither", "R on L"))

#=========================================================================================
#绘制地图
#=========================================================================================
#从maps包里面获取地图数据，用geom_polygon()（可以用颜色填充）或者geom_path()(不能填充)绘制。
#经度和维度默认时画在直角坐标系中的，但是你可以用coord_map()指定一个投影。
#默认的投影时“mercator”，和直角坐标不一样，
#“mercator”中维度线之间的距离会逐渐发生变化

library(maps) #为了使用地图数据
#美国地图数据
states_map <- map_data("state") #必须载入ggplot2以使用map_data

ggplot(states_map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white", colour="black")

#geom_path(没有填充)和mercator投影
ggplot(states_map, aes(x=long, y=lat, group=group)) +
  geom_path()+coord_map("mercator")

#map_data()函数返回的是一个含有如下几列的数据框
#long： 纬度
#lat： 经度
# group: 这是每个多边形的分组变量。一个区域或子区域可能有多个多边形。例如：如果它含有岛屿。
# order:在一组里面每个点的连接顺序
# region：基本时国家和地区的名字，也有其他的对象
# subregion： 一个区域中子区域的名字，可能包含多个组别。


#世界地图数据
world_map <- map_data("world")
world_map
#如果想画世界地图中某个没有单独地图数据的区域，可以首先查找区域的名字
sort(unique(world_map$region))
#可以从世界地图中得到指定区域的地图数据
euro <- map_data("world", region = c("UK", "France", "Netherlands", "Belgium"))
#Map region to fill color
ggplot(euro, aes(x=long, y=lat, group=group, fill=region)) +
  geom_polygon(colour="black") +
  scale_fill_brewer(palette = "Set2") +
  scale_y_continuous(limits = c(40, 60)) +
  scale_x_continuous(limits = c(-25, 25))

#如果一个区域有单独的地图，如nz（新西兰），那么地图数据就会比从世界地图中提取出的数据的分辨率搞
#从世界地图中得到新西兰地图数据
nz1 <- map_data("world", region = "New Zealand") 
nz2 <- subset(nz1, long > 0 & lat > -48) #剔除岛屿
ggplot(nz1, aes(x=long, y=lat, group=group)) + geom_path()
#从新西兰地图中得到新西兰地图数据
nz2 <- map_data("nz")
ggplot(nz2, aes(x=long, y=lat, group=group)) + geom_path()

#=========================================================================================
#绘制等值区域图
#=========================================================================================
#把变量值和地图数据合并在一起，然后把一个变量映射到fill上。

#把USArrests数据集转换成正确的格式
crimes <- data.frame(state = tolower(rownames(USArrests)), USArrests)
crimes

library(maps) #为了使用地图数据
states_map <- map_data("state")
#合并数据集
crime_map <- merge(states_map, crimes, by.x = "region", by.y = "state")
#合并之后，顺序发生了变化，可能会导致多边形位置不对，所以要对数据排序
head(crime_map)

library(plyr) #为了使用arrange()函数
#按照group, order排序
crime_map <- arrange(crime_map, group, order)
head(crime_map)

#当数据的格式正确时，就可以画出图形，把其中一列数值映射到fill上
ggplot(crime_map, aes(x=long, y=lat, group=group, fill=Assault)) +
  geom_polygon(colour="black") +
  coord_map("polyconic")
#这个例子用的是默认的颜色标度，从深蓝渐变到浅蓝。
#如果想展示变量值是如何从某个中点值向外发散的，可以用scale_fill_gradient2()
ggplot(crimes, aes(map_id=state, fill=Assault)) +
  geom_map(map = states_map, colour="black") +
  scale_fill_gradient2(low = "#559999", mid = "grey90", high = "#BB650B",
                       midpoint = median(crimes$Assault)) +
  expand_limits(x=states_map$long, y=states_map$lat) +
  coord_map("polyconic")

#找到分位数的边界
qa <- quantile(crimes$Assault, c(0,0.2,0.4,0.6,0.8,1.0))
qa
#加入一个分位数类别的列
crimes$Assault_q <- cut(crimes$Assault, qa,
                        labels = c("0-20%", "20-40%", "40-60%", "60-80%", "80-100%"),
                        include.lowest = TRUE)
crimes

#产生一个有5个离散取值的调色板
pal <- colorRampPalette(c("#559999", "grey80", "#BB650B"))(5)
pal

ggplot(crimes, aes(map_id = state, fill=Assault_q)) +
  geom_map(map = states_map, colour="black") +
  scale_fill_manual(values = pal) +
  expand_limits(x=states_map$long, y=states_map$lat) +
  coord_map("polyconic") +
  labs(fill="Assault Rate\nPercentile")
  
#crimes中的‘state'列要和states_map中的’region'列匹配
ggplot(crimes, aes(map_id = state, fill=Assault_q)) +
  geom_map(map = states_map) +
  scale_fill_manual(values = pal) +
  expand_limits(x=states_map$long, y=states_map$lat) +
  coord_map("polyconic")
#=========================================================================================
#创建空白背景的地图
#=========================================================================================
#首先保存下面的主题

#船舰一个去掉了很多背景元素的主题
theme_clean <- function(base_size=12){
  require(grid) #unit()函数需要
  theme_grey(base_size) %+replace%
    theme(
      axis.title = element_blank(),
      axis.text = element_blank(),
      panel.background = element_blank(),
      panel.grid = element_blank(),
      axis.ticks.length = unit(0, "cm"),
      axis.ticks.margin = unit(0, "cm"),
      panel.margin = unit(0,"lines"),
      plot.margin = unit(c(0,0,0,0), "lines"),
      complete = TRUE
    )
}

#然后把它加在地图上。
ggplot(crimes, aes(map_id = state, fill=Assault_q)) +
  geom_map(map = states_map, colour="black") +
  scale_fill_manual(values = pal) +
  expand_limits(x=states_map$long, y=states_map$lat) +
  coord_map("polyconic") +
  labs(fill="Assault Rate\nPercentile") +
  theme_clean()

#=========================================================================================
#基于空间数据格式（shapefile）创建地图
#=========================================================================================
# #用maptools包中的readShapePoly()载入空间数据文件，用fortify()把数据转化成数据框的格式，然后画图
# library(maptools)
# #载入空间数据并转化成数据框
# uk_shp <- readShapePoly("GBR_adm/GBR_adm2.shp")
# uk_map <- fortify(uk_shp)
# 
# ggplot(uk_map, aes(x=long, y=lat, group=group)) + geom_path()
# 
# uk_shp <- readShapePoly()


