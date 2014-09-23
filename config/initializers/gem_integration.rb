class MindpinHTMLDiff
  class << self
    include HTMLDiff
  end
end

module KnowledgeNetPlanStore
  class Plan
    belongs_to :net,
               :class_name => "KnowledgeNetStore::Net"
  end

  class Topic
    include StandardSearch

    standard :title, :desc

    has_and_belongs_to_many :points,
                            :class_name => "KnowledgeNetStore::Point"

    def net
      plan.net
    end
  end

  class Tutorial
    include KnowledgeCamp::Step::Owner
    include PinyinSearch

    has_and_belongs_to_many :points,
                            :class_name => "KnowledgeNetStore::Point"

    belongs_to :creator, :class_name => User.name

    validates :creator_id, :presence => true

    pinyin :title
    standard :desc

    alias old_attrs    attrs

    def attrs
      old_attrs.merge(:creator => creator.info)
    end

    def clone
      tutorial = self.class.new

      tutorial.update_attributes(:title      => self.title,
                                 :desc       => self.desc,
                                 :creator_id => self.creator_id,
                                 :topic_id   => self.topic_id,
                                 :image      => self.image,
                                 :point_ids  => self.point_ids)

      mappings = self.steps.reduce([]) do |array, step|
        array << {
          :old => step,
          :new => tutorial.steps.create(:title => step.title)
        }

        array
      end

      find_new = ->(old_id) {
        mappings.detect do |h|
          h[:old].id.to_s == old_id
        end[:new]
      }

      mappings.each do |hash|
        old = hash[:old]
        new = hash[:new]

        case old.continue[:type]
        when :step
          new.set_continue(:step,
                           find_new.call(old.continue[:id].to_s).id)
        when :select
          new.set_continue(:select,
                           :question => old.continue[:question],
                           :options  => old.continue[:options].clone.map {|option|
                             option[:id] = find_new.call(option[:id]).id
                             option
                           })
        when :end
          new.set_continue(false)
        end

        new.block_order = old.blocks.map do |block|
          new_block = block.clone
          new_block.save
          new_block
        end.map(&:id)

        new.save
      end

      tutorial.step_ids = mappings.map {|hash| hash[:new].id}
      tutorial.save

      tutorial
    end
  end
end

module KnowledgeNetStore
  class Point
    include PinyinSearch

    has_and_belongs_to_many :tutorials,
                            :class_name => "KnowledgeNetPlanStore::Tutorial"

    pinyin :name
  end
end

# -----------------------------------------
# virtual_file_system 相关
module FileEntityVFSModule
  def get_uri(store_id)
    {
      :type => :disk,
      :value => FilePartUpload::FileEntity.find(store_id).attach.path
    }
  end

  def file_info(store_id)
    fe = FilePartUpload::FileEntity.find(store_id)
    {
      :size => fe.attach.size,
      :mime_type => fe.attach.content_type, # MIME TYPE
      :mime_type_info => {}
    }
  end
end

VirtualFileSystem.config do 
  bucket :knowledge_net, :store => :file_entity
end

module VirtualFileSystem
  class File
    belongs_to :net,
               :class_name => 'KnowledgeNetStore::Net'

    field :visible_name, :type => String

    has_and_belongs_to_many :points,
                            :class_name => 'KnowledgeNetStore::Point',
                            :inverse_of => :virtual_files
    has_one :block,
            :class_name => 'KnowledgeCamp::Block'

    default_scope -> { order_by(:updated_at => :desc) }

    field :width,    :type => Integer
    field :height,   :type => Integer
    field :duration, :type => Integer

    alias old_width    width
    alias old_height   height
    alias old_duration duration

    def width
      return if !image?
      get_dimension! if !old_width
      old_width
    end

    def height
      return if !image?
      get_dimension! if !old_height
      old_height
    end

    def duration
      return if !video?
      get_duration! if !old_duration
      old_duration
    end

    def attrs
      {
        :id           => self.id.to_s,
        :is_dir       => self.is_dir,
        :name         => self.name,
        :virtual_path => self.path,
        :created_at   => self.created_at,
        :updated_at   => self.updated_at,
      }.merge(file_entity ? {:url => attach.url} : {})
       .merge(image? ? {:width => width, :height => height} : {})
       .merge(video? ? {:duration => duration} : {})
    end

    def file_entity
      self.store_id ? FilePartUpload::FileEntity.find(self.store_id) : nil
    end

    def image?
      self.attach.content_type.include?("image")
    end

    def video?
      self.attach.content_type.include?("video") ||
      self.attach.content_type.include?("application/mp4")
    end

    def attach
      self.file_entity.attach
    end

    private

    def get_dimension!
      img = MiniMagick::Image.new(attach.path)
      self.width  = img[:width]
      self.height = img[:height]
      self.save if !self.new_record?
    end

    def get_duration!
      vid = FFMPEG::Movie.new(attach.path)
      self.duration = vid.duration
      self.save if !self.new_record?
    end
  end
end

def randstr(length=8)
  base = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  size = base.size
  re = '' << base[rand(size-10)]
  (length - 1).times {
    re << base[rand(size)]
  }
  re
end

def get_virtual_filename(filename)
  filename = filename.to_s
  return "" if filename.blank?
  arr = filename.split(".")
  return "#{filename}-#{randstr(32)}" if arr.count == 1

  extname = arr.pop
  return "#{arr*"."}-#{randstr(32)}.#{extname}"
end

require_relative 'rutil'
FilePartUpload.config do
  path RUtil.get_static_file_path("files/:id/file/:name")
  url RUtil.get_static_file_url("files/:id/file/:name")
end

module FilePartUpload
  class FileEntity
    field :identifier, :type => String
    index({:identifier => 1})
  end
end

# ---------------------------------------

module DocumentsStore
  class Document
    belongs_to :creator,
               :class_name => "User",
               :foreign_key => :creator_id

    belongs_to :last_editor,
               :class_name => "User",
               :foreign_key => :last_editor_id

    belongs_to :net,
               :class_name  => "KnowledgeNetStore::Net",
               :foreign_key => :net_id

    default_scope -> {
      order_by :updated_at => :desc
    }

    before_validation :_set_default_title
    def _set_default_title
      self.title = "无题 #{Time.now.to_s(:db)}" if self.title.blank?
    end

    # 恢复到指定版本
    # version_obj 是对象，不是编号
    # editor 需要传入 current_user
    def restore_version(version_obj, editor)
      self.title = version_obj.title
      self.content = version_obj.content
      self.last_editor = editor
      self.save
    end
  end
end

module KnowledgeNetStore
  class Net
    has_many :documents,
             :class_name => 'DocumentsStore::Document'

    has_many :plans,
             :class_name => 'KnowledgeNetPlanStore::Plan'

    has_many :virtual_files,
             :class_name => 'VirtualFileSystem::File'

    after_create :create_default_plan

    def default_plan
      plans.first
    end

    def topics
      default_plan.topics
    end

    private

    def create_default_plan
      KnowledgeNetPlanStore::Plan.create :title => "default_plan"
    end
  end

  class Point
    has_and_belongs_to_many :virtual_files,
                            :class_name => 'VirtualFileSystem::File',
                            :inverse_of => :points
  end
end

KnowledgeNetStore::Net.send :include, Kaminari::MongoidExtension::Document
VirtualFileSystem::File.send :include, Kaminari::MongoidExtension::Document

KnowledgeNetPlanStore::Uploader.send :include, ImageUploaderMethods

class User
  include KnowledgeCamp::Step::NoteCreator
  include KnowledgeCamp::HasManyLearnRecords

  has_many :virtual_files,
           :class_name => "VirtualFileSystem::File",
           :foreign_key => :creator_id

  has_many :tutorials,
           :class_name => KnowledgeNetPlanStore::Tutorial.name,
           :foreign_key => :creator_id
end

class KnowledgeCamp::Block
  belongs_to :virtual_file,
             :class_name => 'VirtualFileSystem::File'

  alias old_attrs attrs

  def attrs
    vf = self.virtual_file
    old_attrs.merge(vf ? {:virtual_file => vf.attrs} : {})
  end
end

# 载入这两个类以执行他们末尾的include逻辑 
TutorialLearnProgress
TopicLearnProgress
