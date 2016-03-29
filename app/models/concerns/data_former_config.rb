module DataFormerConfig
  FORMER_INFO = {}

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
    base.extend ClassMethods
  end

  module ClassMethods
    def former(class_name, &block)
      FORMER_INFO[class_name] = Former.new(&block).run
    end
  end

end
