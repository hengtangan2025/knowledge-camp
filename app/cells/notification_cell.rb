class NotificationCell < Cell::Rails
  def nav
    @navs = [
      {
        :action => "index",
        :url    => "/bank/notifications",
        :name   => "全部通知"
      },
      {
        :action => "system",
        :url    => "/bank/notifications/system",
        :name   => "系统通知"
      },
      {
        :action => "questions",
        :url    => "/bank/notifications/questions",
        :name   => "问答通知"
      },
      {
        :action => "courses",
        :url    => "/bank/notifications/courses",
        :name   => "课程通知"
      },
    ]
    render
  end

  def get_li_active_class(action)
    action == params[:action] ? "active" : ""
  end
end
