jQuery(document).on 'ready page:load', ->
  configs =
    selector: '.course-one-detail .bucketerize, .course-content .bucketerize'

  window.standard = new Bucketerize(configs)
