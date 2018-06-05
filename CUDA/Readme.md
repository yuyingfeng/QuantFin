# CUDA是什么
## CUDA，Compute Unified Device Architecture的简称，是由NVIDIA公司创立的基于他们公司生产的图形处理器GPUs（Graphics Processing Units,可以通俗的理解为显卡）的一个并行计算平台和编程模型。
## 通过CUDA，GPUs可以很方便地被用来进行并行计算，达到高性能计算目的。NVIDIA公司为了吸引更多的开发人员，对CUDA进行了编程语言扩展，如CUDA C/C++,CUDA Fortran语言。
## 注意CUDA C/C++可以看作一种新的编程语言，NVIDIA 专门为CUDA C/C++配置了相应的编译器nvcc。


# 这个程序是干什么的？
## 我们用CUDA C/C++ 编写了 布莱克-斯科尔斯-莫顿（Black-Scholes-Merton）期权定价公式，实现和演示了并行加速计算。
