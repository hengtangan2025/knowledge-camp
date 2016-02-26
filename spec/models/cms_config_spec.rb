require 'rails_helper'

RSpec.describe CmsConfig, type: :model do
  it "attributes" do
    @cms_config = create(:cms_config)
    expect(@cms_config.respond_to?(:name)).to eq true
    expect(@cms_config.respond_to?(:value)).to eq true
  end

  it 'validates' do
    expect(build(:cms_config, name: nil)).not_to be_valid
  end

  #it '指定显示在导航下拉（nav dropdown）中的课程分类' do
    #@courses = []
    #@courses << create(:course)
    #@courses << create(:course)
    #@courses.each do |course|
      #create(:cms_config, name: 'show_course_subject_in_nav_dropdown', value: course.id)
    #end

    #expect(
      #KcCourses::Course.find(CmsConfig.where(name: 'show_course_subject_in_nav_dropdown').map(&:value))
    #).to eq @courses
  #end

  #it '指定显示在导航中的课程分类' do
    #@courses = []
    #@courses << create(:course)
    #@courses << create(:course)
    #@courses.each do |course|
      #create(:cms_config, name: 'show_course_subject_in_nav_item', value: course.id)
    #end

    #expect(
      #KcCourses::Course.find(CmsConfig.where(name: 'show_course_subject_in_nav_item').map(&:value))
    #).to eq @courses
  #end
end
