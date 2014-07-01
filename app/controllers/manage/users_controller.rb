class Manage::UsersController < BaseGenericController
  before_filter :authenticate_user!
  
  set_model User,
    :allow_attrs  => []

  def index
    @users = User.all.order_by("created_at ASC").page(params[:page]).per(12)
  end

  def create
    data = params[:users]

    count = 0

    data.each_value do |d|
      login, name = d
      name = login if name.blank?

      user = User.new :login => login, :name => name, :password => '1234'
      count = count + 1 if user.save
    end

    flash[:success] = "创建了 #{count} 个用户"
    render :json => {:count => count}
  end
end