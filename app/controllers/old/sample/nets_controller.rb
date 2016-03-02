class Old::Sample::NetsController < ApplicationController
  def index
    @nets = Explore::Mock.nets[0..1]
    @tutorials = Explore::Mock.tutorials
    # render :json => @tutorials
  end
end
