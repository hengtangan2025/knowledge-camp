class NotFound < Error
  def initialize
    self[:status]  = 404
    self[:subject] = :not_found
    self[:message] = "Not found!"
  end
end
