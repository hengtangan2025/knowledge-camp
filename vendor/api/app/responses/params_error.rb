class BadRequest < Error
  def initialize(message = nil)
    self[:status]  = 400
    self[:subject] = :bad_request
    self[:message] = message || "Bad request!"
  end
end
