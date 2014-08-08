class UnprocessableEntity < Error
  def initialize(message = nil)
    self[:status]  = 422
    self[:subject] = :unprocessable_entity
    self[:message] = message || "Unprocessable entity!"
  end
end
