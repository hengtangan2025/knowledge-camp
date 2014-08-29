module DisplayHelpers
  def display(obj, status=200)
    render :json => data(obj), :status => status
  end

  def data(obj)
    if obj.class == Mongoid::Relations::Targets::Enumerable
      return obj.map(&:attrs)
    end

    case obj
    when Hash then obj
    when Array then obj.map {|o| o.is_a?(Hash) ? o : o.attrs}
    when Mongoid::Criteria then obj.map(&:attrs)
    when Error, Mongoid::Document then obj.attrs
    end
  end
end
