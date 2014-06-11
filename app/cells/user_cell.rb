class UserCell < Cell::Rails
  helper :application

  def grid(option = {})
    @users = option[:users]
    render
  end
end