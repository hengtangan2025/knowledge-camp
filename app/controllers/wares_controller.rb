class WaresController < ApplicationController
  layout "new_version_ware"

  def show
    @page_name = 'ware_show'

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
      course: SAMPLE_COURSE_DATA,
      ware: SAMPLE_WARES_DATA.select {|x| x[:id] == params[:id]}.first
    }


    render :page
  end
end
