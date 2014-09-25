开发测试数据导入方法：

需要先运行全文搜索服务：
/download/elasticsearch-1.3.2/bin # ./elasticsearch

1. 导入知识网络
rails r sample-data/knowledge-net-sample-v1/import_demo_data_v1.rb

2. 导入图片资源文件
rails r sample-data/meish_net_vietual_files/import_virtual_files.rb