module KnowledgeCampApi
  class PointsController < ApplicationController
    include KnowledgeNetStore
    include KnowledgeNetPlanStore

    def index
      display resources
    end

    def show
      display Point.find(params[:id])
    end

    private

    def resources
      case query_key
      when :net_id
        Point.where(:net_id => params.require(:net_id))
      when :tutorial_id
        Tutorial.find(params[:tutorial_id]).points
      end
    end

    def query_key
      first_key [
        :net_id,
        :tutorial_id
      ]
    end
  end
end
