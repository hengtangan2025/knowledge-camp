class Bank::MyTestQuestionsController < Bank::ApplicationController
  def records
    render :cell
  end

  def mistakes
    render :cell
  end

  def fav
    render :cell
  end
end
