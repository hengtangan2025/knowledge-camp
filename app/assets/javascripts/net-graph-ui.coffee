jQuery(document).on 'ready page:load', ->
  if jQuery('body.net-graph').length

    seajs.config
      base: '/js/'
      alias:
        'd3': 'd3/d3-3.4.6.min'
      paths:
        'graph': 'knowledge-graph/dist'

    seajs.use 'graph/view', (KnowledgeView)->
      net_id = jQuery('body').data('net')

      jQuery.getJSON "/manage/nets/#{net_id}.json", (data)->
        new KnowledgeView jQuery('.graph-paper'), data