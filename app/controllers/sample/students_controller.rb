class Sample::StudentsController < ApplicationController
  def show
    @learners = Explore::Mock.learners
    @tutorials = Explore::Mock.tutorials
  end
end