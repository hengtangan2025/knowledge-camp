class Error < Struct.new(:status, :subject, :message)
  def attrs
    {
      :subject => subject,
      :message => message
    }
  end
end
