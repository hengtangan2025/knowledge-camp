module Explore
  class StepsController < ApplicationController
    layout 'explore/tutorial', :only => [:show, :finish, :flow]

    def index
    end

    def flow
      @tutorial = Explore::Mock.tutorials.select {|x| x.id.to_s == params[:tutorial_id]}.first

      id = 0
      steps = @tutorial.steps.map {|x|
        id = id + 1
        {
          :id => id,
          :continue => {
            :id => id + 1
          },
          :data => {
            :title => x.title,
            :desc => x.desc,
            :imgs => x.imgs,
            :video => x.video
          }
        }
      }

      @tutorial.steps = Explore::JSONStruct.open(steps.to_json)
      @tutorial.steps.last.continue = 'end'

      # render :json => @tutorial.steps.last
    end

    def show
    end

    def finish
    end
  end
end