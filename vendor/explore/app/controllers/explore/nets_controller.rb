module Explore
  class NetsController < ApplicationController
    def show
      @net = KnowledgeNetStore::Net.find params[:id]
    end
  end
end