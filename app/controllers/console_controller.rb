class ConsoleController < ApplicationController
  def index
    render layout: nil
  end

  def export
    FileUtils.mkdir_p File.join(Rails.root, 'backup')

    case params[:backup]
      when 'ware'
        export_ware
      when 'media_clip'
        export_media_clip
      when 'screen'
        export_screen
      when 'trade'
        export_trade
      when 'xxmx'
        export_xxmx

      when 'subject'
        export_subject
      when 'post'
        export_post
      when 'level'
        export_level
      else
        render layout: nil
      end
  end

  private
  def export_ware
    fname = 'ci-teller_ware.json'
    path = File.join Rails.root, 'backup', fname
    File.open path, 'w' do |f|
      f.write ::Finance::TellerWare.all.as_json.map { |x|
        x.delete '_id'
        x.delete 'creator_id'
        x
      }.to_json
    end

    send_file path, filename: fname
  end

  def export_media_clip
    fname = 'ci-teller_ware_media_clip.json'
    path = File.join Rails.root, 'backup', fname
    File.open path, 'w' do |f|
      f.write ::Finance::TellerWareMediaClip.all.as_json.map { |x|
        x.delete '_id'
        fe = FilePartUpload::FileEntity.find x['file_entity_id']
        x['file_entity'] = fe.as_json
        x['file_entity'].delete '_id'
        x.delete 'file_entity_id'
        x
      }.to_json
    end

    send_file path, filename: fname
  end

  def export_screen
    fname = 'ci-teller_ware_screen.json'
    path = File.join Rails.root, 'backup', fname
    File.open path, 'w' do |f|
      f.write ::Finance::TellerWareScreen.all.as_json.map { |x|
        x.delete '_id'
        x
      }.to_json
    end

    send_file path, filename: fname
  end

  def export_trade
    fname = 'ci-teller_ware_trade.json'
    path = File.join Rails.root, 'backup', fname
    File.open path, 'w' do |f|
      f.write ::Finance::TellerWareTrade.all.as_json.map { |x|
        x.delete '_id'
        x
      }.to_json
    end

    send_file path, filename: fname
  end

  def export_xxmx
    fname = 'ci-teller_ware_xxmx.json'
    path = File.join Rails.root, 'backup', fname
    File.open path, 'w' do |f|
      f.write ::Finance::TellerWareXxmx.all.as_json.map { |x|
        x.delete '_id'
        x
      }.to_json
    end

    send_file path, filename: fname
  end

  def export_subject
    fname = 'ci-finance_subject.json'
    path = File.join Rails.root, 'backup', fname
    File.open path, 'w' do |f|
      f.write ::KcCourses::CourseSubject.all.as_json.map { |x|
        x
      }.to_json
    end

    send_file path, filename: fname
  end

  def export_post
    fname = 'ci-finance_post.json'
    path = File.join Rails.root, 'backup', fname
    File.open path, 'w' do |f|
      f.write ::EnterprisePositionLevel::Post.all.as_json.map { |x|
        x
      }.to_json
    end

    send_file path, filename: fname
  end

  def export_level
    fname = 'ci-finance_level.json'
    path = File.join Rails.root, 'backup', fname
    File.open path, 'w' do |f|
      f.write ::EnterprisePositionLevel::Level.all.as_json.map { |x|
        x
      }.to_json
    end

    send_file path, filename: fname
  end
end