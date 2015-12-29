class Bank::TestPaperResultsController < Bank::ApplicationController
  def new
    @test_paper = QuestionBank::TestPaper.find params[:test_paper_id]
  end

  def create
  end
end
