CmsConfig key对应功能以及设置形式

| Key                                 | 使用地点                                       | 数量 | 类型   | 范例                                                            |
|-------------------------------------|------------------------------------------------|------|--------|-----------------------------------------------------------------|
| footer_logo                         | 底部Logo Url                                   | 1    | 字符串 | http://placehold.it/350x150                                     |
| footer_desc                         | 底部网站描述                                   | 1    | 字符串 | 这是Mindpin                                                     |
| footer_nav                          | 底部链接                                       | 多   | Hash   | {"name"=>"About", "url"=>"http://a.com/b", "open_in_new"=>true} |
| show_course_subject_in_nav_dropdown | 指定显示在导航下拉（nav dropdown）中的课程分类 | 多   | 字符串 | course_subject.id                                               |
| show_course_subject_in_nav_item     | 指定显示在导航中的课程分类                     | 多   | 字符串 | course_subject.id                                               |
