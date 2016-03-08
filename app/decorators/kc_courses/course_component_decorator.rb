KcCourses::Course.class_eval do
  def to_brief_component_data(controller = nil)
    # TODO 课程封面
    # TODO 课程发布时间
    {
      id: self.id.to_s,
      url: controller.course_path(self.id.to_s),
      img: 'http://i.teamkn.com/i/dHCg8ulr.png',
      name: self.title,
      desc: self.desc,
      instructor: self.user.name,
      published_at: self.updated_at.strftime("%Y-%m-%d")
    }
  end

  def to_detail_component_data(controller = nil)
    {
      id: self.id.to_s,
      url: controller.course_path(self.id.to_s),
      img: 'http://i.teamkn.com/i/dHCg8ulr.png',
      name: self.title,
      desc: self.desc,
      instructor: self.user.name,
      published_at: self.updated_at.strftime("%Y-%m-%d"),
      # TODO 统计信息方法等待封装完成
      subjects: self.course_subjects.map{|subject| {name: subject.name, url: controller.subject_path(subject.id.to_s)}},
      price: '免费',
      effort: '4 个视频，合计 120 分钟',

      chapters: self.chapters.map{|chapter|chapter.to_brief_component_data(controller)}
    }
  end
end

KcCourses::Chapter.class_eval do
  def to_brief_component_data(controller = nil)
    {
      name: self.title,
      wares: self.wares.map{|ware|ware.to_brief_component_data(controller)}
    }
  end
end

KcCourses::Ware.class_eval do
  def to_brief_component_data(controller = nil)
    percent = self.read_percent_of_user(controller.current_user)
    learned = 'done' if percent == 100
    learned = 'half' if percent > 0 && percent < 100
    learned = 'no'   if percent == 0

    data = {
      id: self.id.to_s,
      name: self.title,
      url: controller.ware_path(self.id.to_s),
      kind: self._type,
      learned: learned,
    }

    data[:kind] = "document"
    if self._type == "KcCourses::SimpleAudioWare"
      data[:kind] = "audio" 
      seconds = self.file_entity.meta[:audio][:audio_duration].to_i
      data[:time] = "#{seconds/60}′#{seconds%60}″"
    end

    if self._type == "KcCourses::SimpleVideoWare"
      data[:kind] = "video"
      seconds = self.file_entity.meta[:video][:total_duration].to_i
      data[:time] = "#{seconds/60}′#{seconds%60}″"
      data[:video_url] = self.file_entity.transcode_url("超请") || 
        self.file_entity.transcode_url("高请") || 
        self.file_entity.transcode_url("标清") ||
        self.file_entity.transcode_url("低清")
    end

    data
  end
end
