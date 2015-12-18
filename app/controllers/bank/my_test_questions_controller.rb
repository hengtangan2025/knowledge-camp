class Bank::MyTestQuestionsController < Bank::ApplicationController
  def records
    @question_records = current_user.question_records

    if params[:is_correct] != nil
      @question_records = @question_records.with_correct(params[:is_correct])
    end

    if params[:kind] != nil
      @question_records = @question_records.with_kind(params[:kind])
    end

    if params[:time] != nil
      time_query_hash = {
        "a_week"       => {:start_time => (Date.today - 6).to_time,  :end_time => Time.now.to_time},
        "a_month"      => {:start_time => (Date.today - 30).to_time, :end_time => Time.now.to_time },
        "three_months" => {:start_time => (Date.today - 90).to_time, :end_time => Time.now.to_time }
      }
      time_query_hash.default = {:start_time => nil,:end_time => nil}
      @question_records = @question_records.with_created_at(time_query_hash[params[:time]])
    end

  end

  def flaw
    @question_flaws = current_user.question_flaws

    if params[:kind] != nil
      @question_flaws = @question_flaws.with_kind(params[:kind])
    end

    if params[:time] != nil
      time_query_hash = {
        "a_week"       => {:start_time => (Date.today - 6).to_time,:end_time => Time.now.to_time},
        "a_month"      => {:start_time => (Date.today - 30).to_time,:end_time => Time.now.to_time },
        "three_months" => {:start_time => (Date.today - 90).to_time,:end_time => Time.now.to_time }
      }
      time_query_hash.default = {:start_time => nil,:end_time => nil}
      @question_flaws = @question_flaws.with_created_at(time_query_hash[params[:time]])
    end
  end

  def fav
    bucket     = current_user.buckets.where(name: '默认').first_or_create
    @questions = bucket.questions


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


  def do_form
    @question = QuestionBank::Question.find params[:id]
  end

  def random
    @question = QuestionBank::Question.skip(rand(QuestionBank::Question.count)).first
  end

  def do
    question = QuestionBank::Question.find params[:id]

    record = question.question_records.new(
      :user          => current_user,
      :answer        => params[:answer]
    )
    record.save
    render :json => {:message => "success"}
  end
end
