jQuery(document).on 'ready page:load', ->
  configs =
    bucket_type: "Folder"
    resource_type: "KcCourses::Course"
    path_fix: "/bank/bucketerize"
    mode: 'modal'

  window.bucketerize = new Bucketerize(configs)
  window.bucketerize.get_resources_buckets()
