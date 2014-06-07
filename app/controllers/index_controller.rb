class IndexController < ApplicationController
  def index
    redirect_to [:manage, KnowledgeNetStore::Net], :status => 301
  end
end