module KnowledgeCampApi
  class PointsController < ApplicationController
    def index
      display resources.map {|point|
        point.attrs.merge(:color => string_grid_color(point.id.to_s).to_s)
      }
    end

    def show
      color = {:color => string_grid_color(params[:id]).to_s}

      display KnowledgeNetStore::Point.find(params[:id])
                                      .attrs
                                      .merge(color)
    end

    private

    def resources
      case query_key
      when :net_id
        KnowledgeNetStore::Point.where(:net_id => params.require(:net_id))
      when :tutorial_id
        KnowledgeNetPlanStore::Tutorial.published.find(params[:tutorial_id]).points
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
