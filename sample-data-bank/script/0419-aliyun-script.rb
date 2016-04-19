::Finance::TellerWare.destroy_all
::Finance::TellerWareScreen.destroy_all
::Finance::TellerWareTrade.destroy_all
::Finance::TellerWareXxmx.destroy_all
::Finance::TellerWareMediaClip.destroy_all

dir = '/web/ben7th/temp/20160419-16-41'

# 课件
JSON.parse(File.read File.join(dir, 'ci-teller_ware.json')).each { |x| 
  c = ::Finance::TellerWare.new(x)
  c.creator = User.first
  c.save 
}

# 交易画面
JSON.parse(File.read File.join(dir, 'ci-teller_ware_screen.json')).each { |x| 
  ::Finance::TellerWareScreen.create(x) 
}

# 交易关联
JSON.parse(File.read File.join(dir, 'ci-teller_ware_trade.json')).each { |x| 
  ::Finance::TellerWareTrade.create(x) 
}

# 选项明细
JSON.parse(File.read File.join(dir, 'ci-teller_ware_xxmx.json')).each { |x| 
  ::Finance::TellerWareXxmx.create(x) 
}

# 课件媒体资源
JSON.parse(File.read File.join(dir, 'ci-teller_ware_media_clip.json')).each { |x| 
  file_entity_data = x.delete 'file_entity'
  # file_entity_data['token'] = "upload/#{file_entity_data['token'].split("/").last}"
  file_entity = FilePartUpload::FileEntity.create(file_entity_data)

  ftc = ::Finance::TellerWareMediaClip.new(x)
  ftc.file_entity = file_entity
  ftc.save 
}


KcCourses::CourseSubject.destroy_all
EnterprisePositionLevel::Level.destroy_all
EnterprisePositionLevel::Post.destroy_all

JSON.parse(File.read File.join(dir, 'ci-finance_subject.json')).each { |x| 
  id = x.delete '_id'
  x['id'] = id['$oid']
  x['parent_id'] = x['parent_id']['$oid'] if x['parent_id']
  x['parent_ids'] = x['parent_ids'].map {|pid|
    pid['$oid']
  }

  KcCourses::CourseSubject.create(x)
}

JSON.parse(File.read File.join(dir, 'ci-finance_level.json')).each { |x| 
  id = x.delete '_id'
  x['id'] = id['$oid']

  EnterprisePositionLevel::Level.create(x)
}

JSON.parse(File.read File.join(dir, 'ci-finance_post.json')).each { |x| 
  id = x.delete '_id'
  x['id'] = id['$oid']

  EnterprisePositionLevel::Post.create(x)
}