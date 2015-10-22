class Bank::NotificationsController < Bank::ApplicationController
  Notification = Struct.new(:content, :user, :kind, :created_at)

  def index
    @notifications = [
      Notification.new("欢迎使用 KcFinance", current_user, "system", "2014-02-09 10:26"),
      Notification.new("XXX 课程有更新", current_user, "courses", "2014-02-09 10:26"),
      Notification.new("问题 XXX 有更新", current_user, "questions", "2014-02-09 10:26")
    ]
  end

  def system
    @notifications = [
      Notification.new("欢迎使用 KcFinance", current_user, "system", "2014-02-09 10:26")
    ]
    render :index
  end
end
