###
屏幕字段属性含义：

参考：
http://mindpin-mockup.oss-cn-shenzhen.aliyuncs.com/kc-finance%2Fdocs%2F%E5%89%8D%E5%8F%B0%E5%BC%80%E5%8F%91%E5%B9%B3%E5%8F%B0%E7%9A%84%E6%95%B0%E6%8D%AE%E5%BA%93%E8%AE%BE%E8%AE%A1-%E5%86%85%E5%90%AB%E4%BA%A4%E6%98%93%E7%94%BB%E9%9D%A2%E6%9F%A5%E8%AF%A2%E8%AF%B4%E6%98%8E.doc

czfs  操作方式  0-编辑；1-输出；2-显示；3-隐藏
qsh   起始行
qsl   起始列
sjbm  数据编码
sjlx  数据类型  0：字符；1：整数；2：实数；3：日期；4：金额；5：数字；6：密码；7：可变长字符串
xssx  显示属性  第一位：0-正常；1-高亮；2-反相；3-下划线；4-暗淡；5-闪烁；6-边框；7-彩色；
               第二位：0-F前景色
               第三位：0-F背景色
xxdm  选项代码  根据这个查询 xxmx 表
zdbt  字段标题
zdcd  字段长度
zdlx  字段类型  0：文本；1：数据；2：选择
zdxh  字段序号  排序用

###

@OFCTellerScreen = React.createClass
  displayName: 'OFCTellerScreen'
  getInitialState: ->
    hmdm: @props.data.hmdm
    zds: @props.data.zds
    xxdm_url: @props.data.xxdm_url

  render: ->
    <div className='ofc-teller-screen'>
      <span className='hmdm'>画面代码: {@state.hmdm}</span>
      <div className='zds'>
        {
          for zd in @state.zds
            <OFCTellerScreen.ZD key={zd.zdxh} data={zd} screen={@} />
        }
      </div>
    </div>

  statics:
    ZD: React.createClass
      render: ->
        data = @props.data
        lh = 480 / 20

        top = (data.qsh - 0) * lh
        left = (data.qsl - 0) * lh * 0.3
        width = data.zdcd * lh * 0.3

        klass = ['zd']
        czfs = ['edit', 'output', 'show', 'hide'][data.czfs]
        klass.push "czfs-#{czfs}"

        style =
          top: top
          left: left

        ipt = switch data.zdlx
          when '2'
            <OFCTellerScreen.Select style={width: width + 30} data={data} screen={@props.screen} />
          else
            <input type='text' style={width: width} readOnly />
            

        <div {...data} className={klass.join(' ')} style={style}>
          <label>{data.zdbt}</label>
          {ipt}
        </div>

    Select: React.createClass
      getInitialState: ->
        loaded: false
        xxmxs: []

      render: ->
        style = @props.style

        <select readOnly style={style} onMouseOver={@show_select}>
          <option>请选择：</option>
          {
            for xxmx, idx in @state.xxmxs
              <option key={idx}>{xxmx.xxqz}- {xxmx.xxmc}</option>
          }
        </select>

      show_select: (evt)->
        return if @state.loaded

        jQuery.ajax
          url: @props.screen.state.xxdm_url
          data:
            xxdm: @props.data.xxdm
        .done (res)=>
          @setState
            loaded: true 
            xxmxs: res