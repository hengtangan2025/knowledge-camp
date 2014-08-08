module KnowledgeCampApi
  class NetsController < ApplicationController
    include KnowledgeNetStore

    def index
      display Net.includes(:points).all
    end

    def show
      display Net.find(params[:id])
    end
  end
end
