::Bank::BusinessCategory.destroy_all

path = File.join Rails.root, 'sample-data-bank', '0421', 'prepared-business-categories.json'
JSON.parse(File.read path).each { |x|
  c = ::Bank::BusinessCategory.new(
    id: x['id'],
    name: x['xmmc'],
    number: x['jydm'],
    parent_id: x['parent_id'].present? ? x['parent_id'] : nil
  )
  c.save
}