class LayoutCell < Cell::Rails
  def nav(options)
    @user = options[:user]
    render
  end
end