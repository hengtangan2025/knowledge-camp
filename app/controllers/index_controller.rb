class IndexController < ApplicationController
  def index
    redirect_to "/knowledge_nets", :status => 301
  end
end