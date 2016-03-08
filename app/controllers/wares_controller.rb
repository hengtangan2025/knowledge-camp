class WaresController < ApplicationController
  layout "new_version_ware"

  def show
    @page_name = 'ware_show'
    
    ware = KcCourses::Ware.find params[:id]

    @component_data = {
      comments: [
        {
          author: {
            name: '若水之约',
            avatar: 'http://i.teamkn.com/i/mT5dd6tj.png',
          },
          content: '好，很细致',
          date: '2016-02-02',
        },
        {
          author: {
            name: 'ia0020028',
            avatar: 'http://i.teamkn.com/i/c0qMJWx9.png',
          },
          content: '讲得蛮好，课程再出多些就好了，期待后续',
          date: '2016-02-02',
        },
        {
          author: {
            name: '轩维诗',
            avatar: 'http://i.teamkn.com/i/ws2SUCrM.png',
          },
          content: '很详细，就是太累了',
          date: '2016-02-02',
        },
      ],
      course: ware.chapter.course.to_detail_component_data(self),
      ware: ware.to_brief_component_data(self)
    }


    render :page
  end
end
