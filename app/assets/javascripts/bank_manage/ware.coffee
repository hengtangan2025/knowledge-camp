class FileEntityCkPlayer
  constructor: (@$ele)->
    console.log 1
    @xml_url = @$ele.data("xmlUrl")
    @url     = ["#{@$ele.data("url")}->video/mp4"]

    @flashvars =
      f: @xml_url
      a: 33
      s: 2
      c: 0
      v: 100
      h: 1

    @params =
      bgcolor: '#FFF'
      allowFullScreen: true
      allowScriptAccess: 'always'
      wmode: 'transparent'

    @swf_url = '/assets/file_part_upload/ckplayer/ckplayer.swf'

    @init_ckplayer()

  init_ckplayer: ->
    console.log this
    CKobject.embed @swf_url, @$ele.attr('id'),
      "ckplayer_#{@$ele.attr('id')}", '100%', '100%', true, @flashvars, @url, @params

jQuery(document).on 'ready page:load', ->
  if jQuery(".page-ware-preview .ckplayer").length != 0
    new FileEntityCkPlayer jQuery(".page-ware-preview .ckplayer")
  
  if jQuery('.ware-preview-qrcode').length != 0
    jQuery('.ware-preview-qrcode').popover
      placement: 'bottom'
      trigger: 'hover'
      html: true
      template: '<div class="popover qrcode" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>'

    jQuery('.ware-preview-qrcode').on 'shown.bs.popover', (evt)->
      jQuery('.popover.qrcode .qrcode').each ->
        url = jQuery(this).data("url")
        jQuery(this).qrcode
          text: url
          width: 230
          height: 230
          
  if jQuery(".image_slider").length != 0
    img_width = jQuery(".image_slider").data("pageWidth")
    img_height = jQuery(".image_slider").data("pageHeight")

    width  = jQuery("#image_slider_container").closest("div").width()
    height = width * img_height / img_width
        
    # jQuery("#image_slider_container").css("width", width)
    jQuery("#image_slider_container").css("height", height)
    # jQuery('#image_slider_container .slides').css("width", width)
    jQuery('#image_slider_container .slides').css("height", height)
    
    options = 
      $AutoPlay: false
      $SlideWidth: width - 10
      $SlideSpacing: 0
      $Cols: 2
      $Align: 5
      $Loop: 1
      $FillMode: 0
      
    slider = new $JssorSlider$('image_slider_container', options)
    slider.$On $JssorSlider$.$EVT_PARK, (slide_index)->
      jQuery('.footer .page-info').text("#{slide_index + 1} / #{slider.$SlidesCount()}")
    
    jQuery('#image_slider_container .slides img').each ->
      console.log jQuery(this)
      new RTP.PinchZoom jQuery(this)