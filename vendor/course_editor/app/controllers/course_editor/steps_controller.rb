module CourseEditor
  class StepsController < ApplicationController
    def create
      @tutorial = KnowledgeNetPlanStore::Tutorial.find params[:tutorial_id]
      step = @tutorial.steps.create

      render :json => {
        :id => step.id.to_s,
        :title => step.title,
        :total_count => @tutorial.steps.count
      }
    end

    def destroy
      step = KnowledgeCamp::Step.find params[:id]
      step.destroy

      tutorial = step.stepped

      render :json => {
        :id => step.id.to_s,
        :total_count => tutorial.steps.count
      }
    end

    def update_continue
      step = KnowledgeCamp::Step.find params[:id]
      data = params[:continue]

      if data['kind'] == 'step'
        step.set_continue 'step', data['id']
      end

      render :json => step.continue
    end
  end
end