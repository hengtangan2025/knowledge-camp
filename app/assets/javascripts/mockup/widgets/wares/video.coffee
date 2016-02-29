@Ware ||= {}

@Ware.Video = React.createClass
  render: ->
    <Ware.Video.CKPlayer data={@props.data} />
    {#<Ware.Video.MediaElement data={@props.data} />}

  statics:
    CKPlayer: React.createClass
      render: ->
        @box_id = "video-box-#{@props.data.id}"
        @widget_id = "video-#{@props.data.id}"

        <div className='widget-ware-video'>
          <div className='wbox' id={@box_id}>
          </div>
        </div>

      componentDidMount: ->
        flash_vars = 
          f: @props.data.video_url
          c: 0 # 调用 ckplayer.js 配置

        video = ["#{@props.data.video_url}->video/mp4"]

        CKobject.embed '/ckplayer/6.7/ckplayer.swf', @box_id, @widget_id, '100%', '100%', false, flash_vars, video

        setTimeout =>
          jQuery("##{@box_id}").css
            'width': null
            'height': null
            'background-color': null
        , 1

    MediaElement: React.createClass
      render: ->
        @box_id = "video-box-#{@props.data.id}"
        @widget_id = "video-#{@props.data.id}"

        <div className='widget-ware-video'>
          <div className='wbox' id={@box_id}>
            <video controls='controls' preload='none' id={@widget_id} width='100%' height='100%'>
              <source type='video/mp4' src={@props.data.video_url} />
              <object width='100%'' height='100%' type="application/x-shockwave-flash" data='/mediaelement/flashmediaelement.swf'>
                <param name='movie' value='/mediaelement/flashmediaelement.swf' />
                <param name="flashvars" value="controls=true&file=#{@props.data.video_url}" />
              </object>
            </video>
          </div>
        </div>

      componentDidMount: ->
        window.player = @player = new MediaElementPlayer "##{@widget_id}", {
          # defaultVideoWidth: '100%'
          # defaultVideoHeight: '100%'
          # pluginWidth: '100%'
          # pluginHeight: '100%'
          # 试图修正尺寸 bug，然而这几个参数没什么用
        }

        jQuery(document).on 'ware:toggle-changed', =>
          @player_resize()

      player_resize: ->
        @player.hideControls(false)