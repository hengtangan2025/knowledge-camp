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
    hmdm:     @props.data.hmdm
    zds:      @props.data.zds
    xxdm_url: @props.data.xxdm_url
    selects:  @props.data.selects
    sample_data: @props.data.sample_data || {}

  render: ->
    <div className='ofc-teller-screen'>
      <span className='hmdm'>画面代码: {@state.hmdm}</span>
      <div className='zds'>
        {
          @zds = for zd in @state.zds
            sjbm = zd.sjbm
            init_value = @state.sample_data[zd.sjbm]

            params = 
              key: zd.zdxh
              data: zd
              screen: @
              editable: @props.editable
              init_value: init_value

            <OFCTellerScreen.ZD ref={zd.sjbm} {...params} />
        }
      </div>
    </div>

  get_sample_data: ->
    re = {}
    for zd in @state.zds
      if not jQuery.is_blank(zd.sjbm)
        x = @refs[zd.sjbm]
        re[zd.sjbm] = x.state.value
    re

  statics:
    ZD: React.createClass
      getInitialState: ->
        value: @props.init_value

      render: ->
        data = @props.data
        line_height = 480 / 20
        col_width = line_height * 0.3 

        top   = data.qsh * line_height
        left  = data.qsl * col_width
        width = data.zdcd * col_width

        klass = new ClassName
          'zd': true
          'czfs-edit':    "#{data.czfs}" == '0'
          'czfs-output':  "#{data.czfs}" == '1'
          'czfs-show':    "#{data.czfs}" == '2'
          'czfs-hide':    "#{data.czfs}" == '3'

        ipt_style = 
          display: if width == 0 then 'none' else ''
          width: if "#{data.zdlx}" == '2' then width + 30 else width

        params = 
          style: ipt_style
          readOnly: not @props.editable
          data: data
          onChange: @change
          value: @state.value
          screen: @props.screen

        ipt = 
          switch "#{data.zdlx}"
            when '2'
              <OFCTellerScreen.SelectZD {...params} />
            else
              if "#{data.sjlx}" == '6'
                <input type='password' {...params} />
              else
                <input type='text' {...params} />

        style =
          top: top
          left: left            

        <div {...data} className={klass} style={style}>
          <label>{data.zdbt}</label>
          {ipt}
        </div>

      change: (evt)->
        value = evt.target.value
        @setState value: value

    SelectZD: React.createClass
      getInitialState: ->
        selects = @props.screen.state.selects
        xxdm = @props.data.xxdm

        xxmxs: selects[xxdm]

      render: ->
        params = 
          style: @props.style
          value: @props.value
          onChange: @props.onChange

        <select {...params} >
          <option>请选择：</option>
          {
            for xxmx, idx in @state.xxmxs
              <option key={idx}>{xxmx.xxmc}</option>
          }
        </select>