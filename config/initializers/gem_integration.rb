class MindpinHTMLDiff
  class << self
    include HTMLDiff
  end
end

# -----------------------------------------
# virtual_file_system 相关
module FileEntityVFSModule
  def get_uri(store_id)
    {
      :type => :disk,
      :value => FilePartUpload::FileEntity.find(store_id).path
    }
  end

  def file_info(store_id)
    fe = FilePartUpload::FileEntity.find(store_id)
    {
      :size => fe.file_size,
      :mime_type => fe.mime, # MIME TYPE
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

    default_scope -> { order_by(:updated_at => :desc) }

    def self.point_related(points, type: nil)
      ids = points.pluck(:virtual_file_ids).flatten.uniq
      files = self.where(:id.in => ids).order_by(:id => :asc)

      case type.to_s
      when "image"
        files.select(&:image?)
      when "video"
        files.select(&:video?)
      else
        files
      end
    end

    def image?
      file_entity.kind.image?
    end

    def video?
      file_entity.kind.video?
    end

    def width
      return if !image?
      file_entity.meta["image"]["width"]
    end

    def height
      return if !image?
      file_entity.meta["image"]["height"]
    end

    def duration
      return if !video?
      file_entity.meta["video"]["total_duration"]
    end

    def attrs
      {
        :id           => self.id.to_s,
        :is_dir       => self.is_dir,
        :name         => self.name,
        :virtual_path => self.path,
        :created_at   => self.created_at,
        :updated_at   => self.updated_at,
      }.merge(file_entity ? {:url => file_entity.url} : {})
       .merge(image? ? {:width => width, :height => height} : {})
       .merge(video? ? {:duration => duration} : {})
    end

    def file_entity
      self.store_id ? FilePartUpload::FileEntity.find(self.store_id) : nil
    end

    def image?
      self.file_entity.kind.image?
    end

    def video?
      self.file_entity.kind.video?
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

# ---------------------------------------

module KnowledgeNetStore
  class Net
    has_many :virtual_files,
             :class_name => 'VirtualFileSystem::File',
             :dependent => :destroy
  end

  class Point
    has_and_belongs_to_many :virtual_files,
                            :class_name => 'VirtualFileSystem::File',
                            :inverse_of => :points
  end
end

[
  KnowledgeNetStore::Net,
  VirtualFileSystem::File
].each do |klass|
  klass.send :include, Kaminari::MongoidExtension::Document
end
