class QuestionsController < ApplicationController
  layout "new_version_base"

  def ware
    ware = KcCourses::Ware.find params[:ware_id]

    questions = ware.questions.page(params[:page]).per(15)

    data = questions.map do |question|
      DataFormer.new(question).data
    end

    result = {
      questions: data,
      paginate: DataFormer.paginate_data(questions),
      create_url: questions_path
    }

    render json: result
  end

  def create
    question = QuestionMod::Question.new question_params
    question.creator = current_user
    _process_targetable(question)

    save_model(question) do |q|
      DataFormer.new(q).data
    end
  end

  private
  def _process_targetable(question)
    if params[:ware_id].present?
      question.targetable = KcCourses::Ware.find params[:ware_id]
    end
  end

  def question_params
    params.require(:question).permit(:title, :content)
  end
end
