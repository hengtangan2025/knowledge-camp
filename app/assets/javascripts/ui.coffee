seajs.config
  base: '/assets/'
  alias:
    'd3': 'd3/d3-3.4.6.min'

seajs.use 'knowledge/view', (KnowledgeView)->
  jQuery ->
    if jQuery('body.graph').length
      net_id = jQuery('body').data('net')

      jQuery.getJSON "/knowledge_nets/#{net_id}.json", (data)->
        new KnowledgeView jQuery('.graph-paper'), data