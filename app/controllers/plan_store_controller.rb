class PlanStoreController < ApplicationController
  include KnowledgeNetPlanStore

  before_action :find_model_instance,
                :only => [
                  :update, :show, :destroy
                ]

  delegate :model, :to => :class

  def self.show_with(&block)
    define_method :show do
      instance_eval &block
    end
  end

  def self.update_with(&block)
    define_method :update do
      model_instance.update_attributes model_params
      model_instance.save
      instance_eval &block
    end
  end

  def self.destroy_with(&block)
    define_method :destroy do
      model_instance.destroy
      instance_eval &block
    end
  end

  def self.set_model(klass)
    @_model = klass
  end

  def self.model
    @_model
  end

  protected

  def find_model_instance
    instance_variable_set model_ivar, model.find(params[:id])
  end

  def model_instance
    instance_variable_get model_ivar
  end

  def model_ivar
    model && "@#{model.model_name.element}"
  end

  def model_params
    params.require(model.model_name.element).permit(:name, :desc)
  end
end
