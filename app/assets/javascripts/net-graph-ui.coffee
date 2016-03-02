jQuery(document).on 'ready page:load', ->
  if jQuery('body.net-graph').length

    seajs.config
      base: '/assets/knowledge_graph_js/'
      alias:
        'd3': 'lib/d3-3.4.6.min'
      paths:
        'graph': 'graph'

    seajs.use 'graph/view', (KnowledgeView)->
      #net_id = jQuery('body').data('net')

      jQuery.getJSON jQuery('body').data('url'), (data)->
        new KnowledgeView jQuery('.graph-paper'), data
