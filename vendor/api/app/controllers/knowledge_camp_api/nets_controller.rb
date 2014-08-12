module KnowledgeCampApi
  class NetsController < ApplicationController
    def index
      display KnowledgeNetStore::Net.all
    end

    def show
      display KnowledgeNetStore::Net.find(params[:id])
    end
  end
end
