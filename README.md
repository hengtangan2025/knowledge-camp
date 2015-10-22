![](http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/CehsqqjM/CehsqqjM.png)

knowledge-camp
==============

学科知识数据库

### 以 development 模式启动步骤说明
```
git clone https://github.com/mindpin/knowledge-camp.git
cd knowledge-camp
git checkout bank
git submodule init
git submodule update
bundle
cp config/initializers/r.rb.development config/initializers/r.rb
rails s -b 0.0.0.0
```

### 导入knowledge-net 数据说明（已过时）
https://github.com/mindpin/sample-data-knowledge-points/blob/master/README.md
