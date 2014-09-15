module PinyinSearch
  extend ActiveSupport::Concern

  included do
    include Searchable

    PinyinSearch.enabled_models.add(self)

    delegate :pinyin_fields, :to => :class

    before_save :save_pinyin_fields
  end

  def self.enabled_models
    @_enabled_models ||= Set.new
  end

  private

  def save_pinyin_fields
    self.pinyin_fields.each do |field|
      value = self.send field

      self.send "#{field}_pinyin=", PinYin.of_string(value).join
      self.send "#{field}_abbrev=", PinYin.abbr(value)
    end
  end

  module ClassMethods
    def pinyin(*fields)
      ext_fields = fields.select do |field|
        self.fields.include?(field.to_s) &&
        self.fields[field.to_s].type == String
      end.each do |f|
        pinyin_fields_from(f).each do |fd|
          field fd, :type => String
        end

        index_pinyin_field(f)
      end

      pinyin_fields.concat ext_fields
    end

    def pinyin_analysis
      {
        :analyzer => {
          :pinyin => {
            :type      => "custom",
            :tokenizer => "lowercase",
            :filter    => ["kc_ngram"]
          }
        },

        :filter => {
          :kc_ngram => {
            :type     => "nGram",
            :min_gram => 1,
            :max_gram => 128
          }
        }
      }
    end

    def pinyin_search(q)
      param = {
        :query => {
          :multi_match => {
            :fields   => [:name_pinyin, :name_abbrev],
            :type     => "phrase",
            :query    => q,
            :analyzer =>"standard"
          }
        }
      }

      self.search(param).records.all
    end

    def pinyin_fields
      @_pinyin_fields ||= []
    end

    private

    def pinyin_fields_from(field)
      %W[#{field}_pinyin #{field}_abbrev]
    end

    def index_pinyin_field(field)
      ext_fields = pinyin_fields_from(field)

      settings :index => {:number_of_shards => 1}, :analysis => self.pinyin_analysis do
        mappings :dynamic => "false" do
          ext_fields.each do |f|
            indexes f, :analyzer => "pinyin"
          end
        end
      end
    end
  end
end
