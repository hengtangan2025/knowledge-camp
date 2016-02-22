class MockupController < ApplicationController
  layout 'mockup'

  def page
    @page_name = params[:page]
  end
end