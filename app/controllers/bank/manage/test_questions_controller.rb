class Bank::Manage::TestQuestionsController < Bank::Manage::ApplicationController
  def index
    @questions = QuestionBank::Question.all.order(:created_at.desc).page(params[:page]).per(16)

    if params[:kind] != nil
      @questions = @questions.with_kind(params[:kind])
    end

    if params[:time] != nil
      time_query_hash = {
        "a_week"       => {:start_time => (Date.today - 6).to_time,:end_time => Time.now.to_time},
        "a_month"      => {:start_time => (Date.today - 30).to_time,:end_time => Time.now.to_time },
        "three_months" => {:start_time => (Date.today - 90).to_time,:end_time => Time.now.to_time }
      }
      time_query_hash.default = {:start_time => nil,:end_time => nil}
      @questions = @questions.with_created_at(time_query_hash[params[:time]])
    end
  end

  def new
    if !QuestionBank::Question::KINDS.include?(params[:kind].to_sym)
      return render :status => 422, :text => 422
    end
    @question = QuestionBank::Question.new(:kind => params[:kind])
    render :form
  end

  def create
    kind = params[:question][:kind]
    hash = send("question_#{kind}_params")
    @question = QuestionBank::Question.new(hash)
    if @question.save
      redirect_to "/bank/manage/test_questions"
    else
      render :form
    end
  end

  def edit
    @question = QuestionBank::Question.find(params[:id])
    @kind = @question.kind
    render :form
  end

  def update
    @question = QuestionBank::Question.find(params[:id])
    @kind = @question.kind
    hash = send("question_#{@kind}_params")
    if @question.update_attributes(hash)
      redirect_to "/bank/manage/test_questions"
    else
      render :form
    end
  end


  def destroy
    @question = QuestionBank::Question.find(params[:id])
    @question.destroy
    redirect_to "/bank/manage/test_questions"
  end

  private
    def question_bool_params
      params.require(:question).permit(:kind, :content, :bool_answer, :analysis, :level, :enabled)
    end

    def question_single_choice_params
      params.require(:question).permit(:kind, :content, :analysis, :level, :enabled, :choices => [], :choice_answer_indexs => [])
    end

    def question_multi_choice_params
      params.require(:question).permit(:kind, :content, :analysis, :level, :enabled, :choices => [], :choice_answer_indexs => [])
    end

    def question_fill_params
      params.require(:question).permit(:kind, :content, :analysis, :level, :enabled, :fill_answer => [])
    end

    def question_mapping_params
      new_mapping_answer = []
      params[:question][:mapping_answer].each { |key,value| new_mapping_answer[key.to_i] = value}
      hash = params.require(:question).permit(:kind, :content, :analysis, :level, :enabled)
      hash[:mapping_answer] = new_mapping_answer
      hash
    end

    def question_essay_params
      params.require(:question).permit(:kind, :content, :analysis, :essay_answer, :level, :enabled)
    end
end
