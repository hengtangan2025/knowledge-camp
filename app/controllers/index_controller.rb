class IndexController < ApplicationController
  def index
    redirect_to KnowledgeNetStore::Net, :status => 301
  end
end