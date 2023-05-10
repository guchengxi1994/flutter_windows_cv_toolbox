# changelog

* 2023-05-10 锐化，双边滤波（为摄像头美颜功能做准备）
* 2023-05-09 优化了camera调用， inpaint实现（同时实现了inpaint组件）
* 2023-05-08 实现了opencv摄像头到flutter widget的实现 （组件dispose的时候可能在timer里使用了setState，会有一点问题，需手动先停止摄像头之后再退出该页面。直接关闭程序没有这个问题）
* 2023-05-07 更新了example
* 2023-05-06 blur
* 2023-05-05 重构
* 2022-08-16 添加`cvtColor`方法
* 2022-08-15 项目初始化，添加盲水印（blind_watermark）方法