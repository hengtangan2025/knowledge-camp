class Unauthorized < Error
  def initialize
    self[:status]  = 401
    self[:subject] = :unauthorized
    self[:message] = "Unauthorized!"
  end
end
