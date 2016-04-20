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
    question = QuestionMod::Question.new question_create_params
    question.creator = current_user

    save_model(question) do |q|
      DataFormer.new(q).data
    end
  end

  private
  def question_create_params
    hash = params.require(:question).permit(:title, :content, :ware_id)
    ware_id = hash.delete :ware_id
    hash[:targetable] = KcCourses::Ware.find(ware_id) if ware_id.present?
    hash
  end
end
