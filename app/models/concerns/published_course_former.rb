module PublishedCourseFormer
  extend ActiveSupport::Concern

  def self.ware_mongodb_data_to_component_data(ware_info, published_course, user, former)
    ware = KcCourses::Ware.find ware_info["id"]
    file_entity = FilePartUpload::FileEntity.find ware_info["file_entity_id"]
    percent = ware.read_percent_of_user(user)
    learned = 'done' if percent == 100
    learned = 'half' if percent > 0 && percent < 100
    learned = 'no'   if percent == 0
    learned

    data = {
      id: ware_info["id"],
      name: ware_info["name"],
      url: former.course_ware_path(ware_id: ware_info["id"], course_id: published_course.id.to_s),
      learned: learned
    }

    if ware_info["_type"] == "KcCourses::SimpleAudioWare"
      data[:kind] = "audio"
      seconds = file_entity.meta[:audio][:audio_duration].to_i
      data[:time] = "#{seconds/60}′#{seconds%60}″"
    end

    if ware_info["_type"] == "KcCourses::SimpleVideoWare"
      data[:kind] = "video"
      seconds = file_entity.meta[:video][:total_duration].to_i
      data[:time] = "#{seconds/60}′#{seconds%60}″"
      data[:video_url] = file_entity.transcode_url("超请") ||
        file_entity.transcode_url("高请") ||
        file_entity.transcode_url("标清") ||
        file_entity.transcode_url("低清")
    end

    data
  end

  included do

    former 'KcCourses::PublishedCourse' do
      field :id, ->(instance) {instance.id.to_s}

      field :img, ->(instance){
        instance.data['cover_file_entity_id'].blank? ? ENV['course_default_cover_url'] : FilePartUpload::FileEntity.find(instance.data['cover_file_entity_id']).url
      }

      field :name, ->(instance) {instance.data["name"]}
      field :desc, ->(instance) {instance.data["desc"]}

      field :instructor, ->(instance) {
        User.find(instance.data["creator_id"]).name
      }

      field :published_at, ->(instance) {
        instance.data["updated_at"].strftime("%Y-%m-%d")
      }

      field :price, ->(instance) {'免费'}

      logic :subjects, ->(instance){
        instance.data["course_subject_ids"].map do |subject_id|
          subject = KcCourses::CourseSubject.find subject_id
          {name: subject.name, url: subject_path(subject.id.to_s)}
        end
      }

      logic :effort, ->(instance){
        wares = instance.data["chapters"].map { |chapter| chapter["wares"] }.flatten
        video_wares = wares.select {|ware| ware["_type"] == "KcCourses::SimpleVideoWare" }
        total_second = video_wares.map do |vw|
          FilePartUpload::FileEntity.find vw[:file_entity_id]
        end.uniq.compact.sum{|fe| fe.seconds.to_i}
        total_minute = total_second / 60
        total_minute = 1 if total_minute == 0 && total_second > 0

        "#{video_wares.count} 个视频，合计 #{total_minute} 分钟"
      }

      logic :chapters, ->(instance, user){
        instance.data['chapters'].map do |chapter|
          wares = chapter["wares"].map do |ware|
            PublishedCourseFormer.ware_mongodb_data_to_component_data(ware, instance, user, self)
          end

          {
            name: chapter["name"],
            wares: wares
          }
        end
      }

      url :url, ->(instance){
        course_path(instance)
      }

    end

  end


end
