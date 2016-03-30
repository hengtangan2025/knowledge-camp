module DataFormerConfig
  FORMER_INFO = {}
  class UndefinedFormerError < StandardError;end
  class UndefinedLogicError < StandardError;end
  class Former
    def initialize(&block)
      @info = {}
      self.instance_eval &block
    end

    def brief(&block)
      @info[:brief] = Brief.new(&block).run
    end

    def logics(&block)
      @info[:logics] = Logics.new(&block).run
    end

    def urls(&block)
      @info[:urls] = Urls.new(&block).run
    end

    def run
      @info
    end
  end

  class Brief
    include Rails.application.routes.url_helpers
    def initialize(&block)
      @info = {}
      self.instance_eval &block
    end

    def field(name, name_block = nil)
      @info[name] = name_block
    end

    def run
      @info
    end
  end

  class Logics
    include Rails.application.routes.url_helpers
    def initialize(&block)
      @info = {}
      self.instance_eval &block
    end

    def logic(name, name_block = nil)
      @info[name] = name_block
    end

    def run
      @info
    end
  end

  class Urls
    include Rails.application.routes.url_helpers
    def initialize(&block)
      @info = {}
      self.instance_eval &block
    end

    def url(name, name_block = nil)
      @info[name] = name_block
    end

    def run
      @info
    end
  end

  def self.included(base)
    base.extend FormerMethod
    base.include BuildMethods
  end

  module BuildMethods
    def initialize(model_instance)
      @model_instance = model_instance
      @info = FORMER_INFO[model_instance.class.to_s]
      if @info.blank?
        raise UndefinedFormerError.new "DataFormer 没有声明 #{model_instance.class.to_s} 的 former"
      end
      @data = {}
    end

    def brief(override_brief = {})
      _build_data_by_brief_info(@info[:brief])
      if !override_brief.blank?
        _build_data_by_brief_info(override_brief)
      end
      self
    end

    def logic(logic_name, *args)
      _proc = @info[:logics][logic_name]
      if _proc.blank?
        raise UndefinedLogicError.new "DataFormer 声明的 #{@model_instance.class.to_s} 的 former 中没有声明 #{logic_name} logic"
      end
      @data[logic_name] = _proc.call(@model_instance, *args)
      self
    end

    def relation(relation_name, override_proc = nil)
      relation = @model_instance.send(relation_name)

      if !override_proc.blank?
        @data[relation_name] = override_proc.call(relation)
        return self
      end

      if relation.methods.include?(:map)
        @data[relation_name] = relation.map do |m|
          DataFormer.new(m).brief.data
        end
      else
        @data[relation_name] = DataFormer.new(relation).brief.data
      end

      self
    end

    def url(url_name, *args)
      _proc = @info[:urls][url_name]
      if _proc.blank?
        raise UndefinedLogicError.new "DataFormer 声明的 #{@model_instance.class.to_s} 的 former 中没有声明 #{url_name} url"
      end
      @data[url_name] = _proc.call(@model_instance, *args)
      self
    end

    def _build_data_by_brief_info(brief_info)
      brief_info.each do |field, _proc|
        if _proc.blank?
          @data[field] = @model_instance.send(field)
        else
          @data[field] = _proc.call(@model_instance)
        end
      end
    end

    def data
      @data
    end
  end

  module FormerMethod
    def former(class_name, &block)
      FORMER_INFO[class_name] = Former.new(&block).run
    end
  end

end
