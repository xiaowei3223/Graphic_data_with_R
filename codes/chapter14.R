
#=========================================================================================
#输出为PDF矢量文件
#=========================================================================================
#有两种方法输出PDF文件。
#一种方法是：使用pdf()打开PDF图形设备，绘制图形，然后使用dev.off()关闭图形设备。
#这种方法适用于R中的大多数图形，包括基础图形和基于网格的图形，如那些有ggplot2和lattice创建的图形：

#width(宽度)和height（高度)的单位为英寸
pdf("myplot.pdf", width = 4, height = 4)
#绘制图形
plot(mtcars$wt, mtcars$mpg)
print(ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point())
dev.off()

#如果你绘制的图形多于一副，则每一幅将在PDF输出中列于独立的一页。
#注意：我们针对ggplot对象调用了print()， 以确保这段代码即使是在一段脚本中也能够输出图形。
#width(宽度)和height（高度）的单位为英寸，所以，要以厘米为单位指定长宽，必须手动执行转换。
#8*8cm
#pdf("myplot.pdf", width = 8/2.54, height = 8/2.54)

#如果使用某个脚本来创建图形，而在创建图形的过程中抛出了一个错误，则R可能无法执行到dev.off()这一步调用，
#并可能停留在PDF设备仍然开启的状态。
#当这种情况发生时，知道你去手动调用dev.off()之前，PDF文件将无法正常打开。

#如果你使用ggplot2创建图形，那么使用ggsave()会简单一些。
#此函数可以简单地保存使用ggplot()创建的最后一幅图形。

ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()

ggsave("myplot2.pdf", width = 8, height = 8, units = "cm")
#=========================================================================================
#输出为SVG矢量文件
#=========================================================================================
#SVG文件在创建和使用的方法上与PDF文件基本相同。
svg("myplot.svg", width = 4, height = 4)
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()
dev.off()

#使用ggsave()
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()
ggsave("myplot2.svg", width = 8, height = 8, units = "cm")


#=========================================================================================
#输出为WMF矢量文件
#=========================================================================================
#WMF文件在创建和使用的方法上与PDF文件基本相同--但这种格式的图形文件只能在windows上创建。
win.metafile("myplot.wmf", width=4, height=4)
dev.off()

#使用ggsave()
ggsave("myplot.wmf", width = 8, height = 8, units = "cm")

#WMF格式的一个缺点是不支持透明（alpha）
#=========================================================================================
#编辑矢量格式的输出文件
#=========================================================================================
#设置参数useDingbats=FALSE,可以使圆圈被绘制为圆圈而不是字体中的字符
pdf("myplot.pdf", width = 4, height = 4, useDingbats = FALSE)
#或者
ggsave("myplot.pdf", width = 4, height = 4, useDingbats=FALSE)


#=========================================================================================
#输出为点阵（PNG/TIFF）文件
#=========================================================================================
#有两种方法可以输出PNG点阵文件
#一种方法使使用png()打开PNG图形设备，绘制图形，然后使用dev.off()关闭设备。
#这种方法对于R中的多数图形都有效，包括基础图形和基于网格的图形，如那些有ggplot2和lattice创建的图形：
#width(宽度)和height（高度）的单位为像素
png("myplot.png", width = 400, height = 400)
#绘制图形
plot(mtcars$wt, mtcars$mpg)
dev.off()

#要输出多幅图形，可在文件名中加入%d。对于后续图形，这个位置将被1、2、3等替代：
#width(宽度)和height(宽度)的单位为像素
png("myplot-%d.png", width = 400, height = 400)
plot(mtcars$wt, mtcars$mpg)
print(ggplot(mrcars, aes(x=wt, y=mpg)) + geom_point())
dev.off()

#width和height的单位为像素，而默认的输出分辨率为每英寸72像素（72ppi）.
#这一分辨率适合在屏幕上显示，但会在打印时显得模糊且有锯齿。

#对于高质量的打印输出，分辨率至少为300ppi。

ppi <- 300
#计算一幅4英寸×4英寸300ppi图像的高度和宽度（以像素为单位）
png("myplot.png", width = 4*ppi, height = 4*ppi, res = ppi)
plot(mtcars$wt, mtcars$mpg)
dev.off()

#如果使用ggplot2创建图形，那么使用ggsave()会简单一些。
#此函数可以简单地保存使用ggplot()创建的最后一幅图形。
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()
ggsave("myplot2.png", width = 8, height = 8, units = "cm", dpi =300)
#=========================================================================================
#在PDF文件中使用字体
#=========================================================================================
#extrafont包可用于创建包含其他字体的PDF文件
#这个过程涉及许多步骤，首先是一些一次性的软件安装和配置。
#下载并安装Ghostscript,然后在R中执行以下命令：
install.packages("extrafont")
library(extrafont)
#查找并保存系统中已安装字体的信息
font_import()
#列出字体
fonts()

#在一次性的安装和设置完成后，需要你在每个新的R会话中执行的是：
library(extrafont)
#在R中注册字体
loadfonts()
#在windos上，你可能需要指定Ghostscript的安装位置
#根据你的Ghostscript安装位置调整对应的路径
#Sys.setenv(R_GSMD = "path/to/Ghostscript")
Sys.setenv(R_GSMD = "/usr/bin/ghostscript")
#最后，你可以创建PDF文件并向其中嵌入字体
library(ggplot2)
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point() +
  ggtitle("Title text goes here") +
  theme(text = element_text(size = 16, family = "Impact"))
ggsave("myplot.pdf", width=4, height=4)  #出错了！！！
embed_fonts("myplot.pdf")
#=========================================================================================
#在windows的点阵或屏幕输出中使用字体
#=========================================================================================
#extrafont包可用于创建包含其他字体的PDF文件
#这个过程涉及许多步骤，首先是一些一次性的软件安装和配置。
#下载并安装Ghostscript,然后在R中执行以下命令：
install.packages("extrafont")
library(extrafont)
#查找并保存系统中已安装字体的信息
font_import()
#列出字体
fonts()

#在一次性的安装和设置完成后，需要你在每个新的R会话中执行的是：
library(extrafont)
#在R中注册字体
loadfonts()
#在windos上，你可能需要指定Ghostscript的安装位置
#根据你的Ghostscript安装位置调整对应的路径
#Sys.setenv(R_GSMD = "path/to/Ghostscript")
Sys.setenv(R_GSMD = "/usr/bin/ghostscript")
#最后，你可以创建PDF文件并向其中嵌入字体
library(ggplot2)
ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point() +
  ggtitle("Title text goes here") +
  theme(text = element_text(size = 16, family = "Impact"))
ggsave("myplot.png", width=4, height=4, dpi=300)  #出错了！！！
