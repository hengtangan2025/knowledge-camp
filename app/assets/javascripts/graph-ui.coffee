if seajs?
  seajs.config
    base: '/js/'
    alias:
      'd3': 'd3/d3-3.4.6.min'
    paths:
      'graph': 'knowledge-graph/dist'

  seajs.use 'graph/view', (KnowledgeView)->
    jQuery ->
      if jQuery('body.graph').length
        net_id = jQuery('body').data('net')

        jQuery.getJSON "/nets/#{net_id}.json", (data)->
          new KnowledgeView jQuery('.graph-paper'), data