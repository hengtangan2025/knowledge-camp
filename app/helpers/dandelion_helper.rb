module DandelionHelper
  def dendelion_new_button(klass)
    render_cell :dandelion, :new_button, :model => klass.new
  end
end