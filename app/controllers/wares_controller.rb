class WaresController < ApplicationController
  layout "new_version_ware"

  def show
    @page_name = 'ware_show'
    
    ware   = KcCourses::Ware.find params[:id]
    course = ware.chapter.course
    @component_data = {
      comments: course.comments.map{|c|c.to_brief_component_data},
      course: ware.chapter.course.to_detail_component_data(self),
      ware: ware.to_brief_component_data(self)
    }

    render :page
  end
end
