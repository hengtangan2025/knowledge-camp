module ImportSampleData
  class VirtualFile
    JSON_PATH = File.expand_path("../../data/virtual_files.json", __FILE__)

    def self.filename_to_tempfile( filename )
      url = File.join("http://oss.aliyuncs.com/pie-documents/20140828/art-imgs/", filename)

      tf = Tempfile.new(["tmp", ".png"])
      tf.binmode
      tf << open(url).read
      tf.rewind
      tf
    end

    def self.import
      p "start import virtual_files.json ..."
      user = User.where(:name => "user1", :login => "user1").first
      net = KnowledgeNetStore::Net.where(:name => "美术知识").first
      command = VirtualFileSystem::Command(:knowledge_net , user)

      data = JSON.parse(IO.read(JSON_PATH))

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

      p "virtual_files.json import success !"
    end
  end
end
