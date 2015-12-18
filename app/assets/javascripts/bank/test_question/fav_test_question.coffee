jQuery(document).on 'ready page:load', ->
  configs =
    selector: '.question-fav .bucketerize'
        
  window.standard = new Bucketerize(configs)
