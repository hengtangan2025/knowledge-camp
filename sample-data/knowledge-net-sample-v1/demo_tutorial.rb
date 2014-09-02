require "open-uri"

net = KnowledgeNetStore::Net.last

plan = net.plans.last

def url_to_file(url, &block)
  ext  = url.gsub(/\?.*/, "").split(".").last
  name = "#{SecureRandom.hex}.#{ext}"
  path = "/tmp/#{name}"

  open(path, "wb") do |f|
    f << open(URI.escape url).read
    block ? [name, path, block.call(f)] : f
  end
end

def add_vfileblock(step, kind, url)
  name, path, fe = url_to_file(url) do |f|
    FilePartUpload::FileEntity.create(:attach => f)
  end

  FileUtils.rm_rf(path)

  command = VirtualFileSystem::Command(:knowledge_net, User.first)

  vfile = command.put("/" + name, fe.id.to_s, :mode => :default) do |vff|
    vff.net = KnowledgeNetStore::Net.last
    vff.visible_name = name
  end

  block = step.add_content(kind, vfile.id)

  binding.pry if block.errors.any?
end

topic_image_url = "http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/bYjKMsbP/adaptive_height_300_bYjKMsbP.png"

_, path, topic = url_to_file(topic_image_url) {|f|
  topic_params = {
    :title  => "测试话题1",
    :desc   => "开发用填充数据.",
    :image  => f
  }

  plan.topics.create(topic_params)
}

FileUtils.rm_rf(path)

binding.pry if topic.errors.any?

tutorial_image_url = "http://mindpin.oss-cn-hangzhou.aliyuncs.com/image_service/images/jwprfBAQ/adaptive_height_300_jwprfBAQ.png"

_, path, tutorial = url_to_file(tutorial_image_url) {|f|
  tutorial_params = {
    :title   => "#{topic.title} - 测试教程1",
    :desc    => "测试教程的描述.",
    :creator => User.first,
    :image   => f
  }

  topic.tutorials.create(tutorial_params)
}

binding.pry if tutorial.errors.any?

FileUtils.rm_rf path

steps = [:a, :b, :b1, :b2, :c].reduce({}) do |a, k|
  a[k] = tutorial.steps.create(:title => "#{tutorial.title} - 第#{k}步")
  a
end

a  = steps[:a]
b  = steps[:b]
b1 = steps[:b1]
b2 = steps[:b2]
c  = steps[:c]

a.set_continue("step", b.id)
a.add_content("text", "心特别容易崩溃生命随年月流去，从来没有，突然模糊的眼睛越是在手心留下密密麻麻深深浅浅的刀割越是在，改变既有的模式！一块钱，哈哈笑笑弄著一条香龙，我记得还似昨天，锣声亦不响了，因為空间的黑暗.")

add_vfileblock(a, :image, "http://www.heroicfantasygames.com/AoD/5.jpg")

a.add_content("text", "奇蹟，明星周新秀挑战赛，终身成就奖漏掉凤飞飞，变调情人节，阿....不会吧???iPad，远比上Google搜寻更有效率.")

add_vfileblock(a, :video, "http://oss.aliyuncs.com/pie-documents/20140729/1-灶台前操作的基本姿势.mp4")


b.set_continue("select", :question => "请选择分支:)", :options => [
                 {:id => b1.id.to_s, :text => "b1"},
                 {:id => b2.id.to_s, :text => "b2"}
               ])

add_vfileblock(b, :video, "http://oss.aliyuncs.com/pie-documents/20140729/1-灶台前操作的基本姿势.mp4")

b.add_content("text", "法拉利时速300km撞毁，高铁北上列车延逾2小时。所以不愿意侧身所谓斯文之列其实也不能够但在不知不觉的中间，不怀著危险的恐惧，地球也规矩地循著唯一的轨道，通溶化在月光裡，波涌似的，自己走出家来.")

b1.set_continue("step", c.id)
b2.set_continue("step", c.id)

b1.add_content("text", "感谢上师，感谢上师，感谢上师，感谢上师，万能的师父。是红色稻草人，去吧，谨遵教诲了，痛苦，这样不要紧吗，拜託你了，雷达卫星导航，那快点找啊，吸血鬼女王，这次的作战就是…")

add_vfileblock(b1, :image, "http://www.heroicfantasygames.com/AoD/5.jpg")

add_vfileblock(b2, :image, "http://www.heroicfantasygames.com/AoD/5.jpg")

b2.add_content("text", "感谢上师，感谢上师，感谢上师，感谢上师，万能的师父。是红色稻草人，去吧，谨遵教诲了，痛苦，这样不要紧吗，拜託你了，雷达卫星导航，那快点找啊，吸血鬼女王，这次的作战就是…")

add_vfileblock(b2, :video, "http://oss.aliyuncs.com/pie-documents/20140729/1-灶台前操作的基本姿势.mp4")

c.set_continue(false)

c.add_content("text", "所以不愿意侧身所谓斯文之列其实也不能够但在不知不觉的中间，不怀著危险的恐惧，地球也规矩地循著唯一的轨道，通溶化在月光裡，波涌似的，自己走出家来，就可自由假设吗？就是，闯入无人婚纱店.")








