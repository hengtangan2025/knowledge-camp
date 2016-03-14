lily
====

4ye.me 所使用的公共 javascript 和 css, 以 git submodule 的形式引用到其他工程之中。原始代码以 sass &amp; coffee 编写。美术设计风格偏向于扁平化。

----------------

### compile

```
scss --watch .
coffee --watch --compile */*.coffee
ruby watch_index_haml.rb .
```

----------------

### run sample

```
ruby -run -e httpd . -p 4000
```

### 依赖的 Gem

fssm, haml, haml-coderay