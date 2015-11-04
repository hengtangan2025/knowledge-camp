jQuery(document).on 'ready page:load', ->
  configs =
    selector: '.bucketerize'

  window.standard = new Bucketerize(configs)