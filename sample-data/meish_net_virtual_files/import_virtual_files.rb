

def filename_to_tempfile( filename )

  url = File.join("http://oss.aliyuncs.com/pie-documents/20140828/art-imgs/", filename)

  tf = Tempfile.new(["tmp", ".png"])
  tf.binmode
  tf << open(url).read
  tf.rewind
  tf
end


net = KnowledgeNetStore::Net.where(:name => "美术知识").first
command = VirtualFileSystem::Command(:knowledge_net , User.first)

data_json_file_path = "../data.json"
json = IO.read(File.expand_path(data_json_file_path, __FILE__))
data = JSON.parse(json)

count = data.count
data.each_with_index do |hash, index|
  p "#{index+1}/#{count}"

  filename = hash["filename"]

  point_ids = hash["points"].map do |pname|
    net.points.where(:name => pname).first.id.to_s
  end

  file = filename_to_tempfile(filename)
  file_entity = FilePartUpload::FileEntity.new(:attach => file)
  file_entity.save

  command.put("/" + file_entity.attach_file_name, file_entity.id, :mode => :default) do |vff|
    vff.net = net
    vff.point_ids = point_ids
  end

end
