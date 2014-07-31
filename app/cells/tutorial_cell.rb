class TutorialCell < Cell::Rails
  helper :application

  def sample_list(tutorials)
    @tutorials = tutorials
    render
  end
end