module KnowledgeCampApi
  class NetsController < ApplicationController
    include KnowledgeNetStore

    def index
      display KnowledgeNetStore::Net.all
    end

    def show
      display Net.find(params[:id])
    end
  end
end
