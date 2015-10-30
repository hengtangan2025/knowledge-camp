jQuery(document).on 'ready page:load', ->
  configs =
    selector: '.like[data-rel=like]'
    resource_type: "KcCourses::Course"
    path_fix: "/bank/bucketerize"
    mode: 'standard'

  window.standard = new Bucketerize(configs)
  window.standard.get_resources_buckets()
