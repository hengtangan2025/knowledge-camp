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
    when Array, Mongoid::Criteria then obj.map(&:attrs)
    when Error, Mongoid::Document then obj.attrs
    end
  end
end
