Batman
======

#### Batman是一个开源的web前端测试框架,主要用来测试基于IE的各种应用,是我个人的一个简单的尝试.
#### Batman框架基于watir测试引擎,并且自己封装了测试框架,希望能帮到需要的人.
#### Batman is an open source automation test framework for web. It's based on watir.
#### 关于
- 设计逻辑
- 
    这是一个来历比较特别的框架.
    之前在利用watir做测试框架的时候,很多文章推荐的都是结合UnitTest这个框架...
    但是我自己的机器上的UnitTest偏偏不好使了...
    所以自己干脆自己写了一个小小的框架来实现自动化测试.
    这个框架的设计理念是轻量级,简单,便于修改,其实说白了,主要还是满足自己的胃口哈 :-)

- 简单入门
- 
    基本上整体框架很好理解: 
        Lib目录: 主要是存放目前测试框架的一些公共方法和对象
            batcase.rb      测试用例的基类
            batdb.rb        主要是用来封装测试中数据库相关的函数,数据库是用来记录测试流程的
            batman.rb       使用module来组织一些公共调用的函数
            batreport.rb    用来封装最后生成测试报告的相关函数
            batrunner.rb    用来存放测试用例运行相关的函数
            kernal.rb       扩展了ruby核心的一些方法
            test_browser    扩展了一个测试浏览器的基类
            doc目录         存放文档的目录
        plan目录: 主要是存放用例运行计划的文件 -- 待完善
            go.rb           运行全部用例的脚本
        case目录: 存放测试用例的目录
        config目录: 存放配置文件的目录
        test_log目录: 存放运行时日志的目录
        test_error_log目录: 存放异常目录的日志
        test_img目录: 存放运行截图的目录
        db目录: 存放数据库文件的目录
    今天更新到这里...下次继续更新

- Author: wangpc
- Twitter: @wangpc
- Mail: wangpc.mobile@gmail.com
 

