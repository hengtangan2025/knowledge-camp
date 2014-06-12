module KnowledgeNetPlanStore
  Plan.send :belongs_to,
            :net,
            :class_name => "KnowledgeNetStore::Net"

  Tutorial.send :has_and_belongs_to_many,
                :points,
                :class_name => "KnowledgeNetStore::Point"
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

VirtualFileSystem::File.send :belongs_to,
                             :net,
                             :class_name => "KnowledgeNetStore::Net"

VirtualFileSystem::File.send :field,
                             :visible_name,
                             :type => String
 

KnowledgeNetStore::Net.send :has_many,
                            :virtual_files,
                            :class_name => "VirtualFileSystem::File"

User.send :has_many,
          :virtual_files,
          :class_name => "VirtualFileSystem::File",
          :foreign_key => :creator_id

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

# ---------------------------------------