module DisplayHelpers
  def display(obj, status=200)
    render data(obj), :status => status
  end

  def data(obj)
    if obj.class == Mongoid::Relations::Targets::Enumerable
      return obj.map(&:attrs)
    end

    case obj
    when Symbol then {obj => true}
    when Hash then {:json => obj}
    when Array then {:json => obj.map {|o| o.is_a?(Hash) ? o : o.attrs}}
    when Mongoid::Criteria then {:json => obj.map(&:attrs)}
    when Error, Mongoid::Document then {:json => obj.attrs}
    end
  end
end
