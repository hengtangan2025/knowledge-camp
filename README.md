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
cp config/application.yml.development config/application.yml
rails s -b 0.0.0.0
```

### 导入knowledge-net 相关数据步骤说明
保证系统启动了 Elasticsearch 服务，如果系统没有安装 Elasticsearch 服务，请参考 https://github.com/mindpin/tech-exp/issues/89 安装

然后运行如下命令
```
cd knowledge-camp
rake import_sample_data:create_data
```
