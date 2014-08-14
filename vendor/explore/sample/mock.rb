module Explore
  class JSONStruct
    class << self
      def open(json_str)
        _r JSON.parse(json_str)
      end

      def _r(obj)
        case obj
        when Array
          obj.map do |x|
            __r(x)
          end
        when Hash
          h = OpenStruct.new({})
          obj.each do |k, v|
            h[k] = __r(v)
          end
          h
        end
      end

      def __r(x)
        if x.is_a?(Hash) || x.is_a?(Array)
          _r(x)
        else
          x
        end
      end
    end
  end

  class Mock
    class << self
      def nets
        # @_nets ||= begin
          json = File.read "vendor/explore/sample/nets.json"
          JSONStruct.open json
        # end
      end

      def tutorials
        # @_tutorials ||= begin
          json = File.read "vendor/explore/sample/tutorials.json"
          arr0 = JSONStruct.open json

          json = File.read "vendor/explore/sample/sp-tutorials.json"
          arr1 = JSONStruct.open json

          arr0 + arr1
        # end
      end

      def learners
        json = File.read "vendor/explore/sample/learners.json"
        JSONStruct.open json
      end
    end
  end
end