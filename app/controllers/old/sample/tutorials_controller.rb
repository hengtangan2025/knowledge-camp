class Old::Sample::TutorialsController < ApplicationController
  def show
    @tutorials = Explore::Mock.tutorials
    @tutorial = @tutorials.select {|x| x.id.to_s == params[:id]}.first
    @learners = Explore::Mock.learners
  end
end
