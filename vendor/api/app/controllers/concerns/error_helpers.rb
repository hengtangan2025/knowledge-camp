module ErrorHelpers
  extend ActiveSupport::Concern

  included {
    rescue_from Mongoid::Errors::DocumentNotFound,       :with => :not_found
    rescue_from ActionController::ParameterMissing,      :with => :bad_request
    rescue_from ActionController::UnpermittedParameters, :with => :bad_request
    rescue_from ActionController::RoutingError,          :with => :not_found
    rescue_from Mongoid::Errors::Validations,            :with => :unprocessable_entity
    rescue_from KnowledgeCamp::NoContentBlock,           :with => :bad_request
  }

  def unprocessable_entity(ex)
    error UnprocessableEntity.new(ex.record.errors.messages)
  end

  def not_found
    error NotFound.new
  end

  def bad_request(ex)
    error BadRequest.new(ex.message)
  end

  def error(error)
    display error, error.status
  end
end
