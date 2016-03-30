require 'rails_helper'

module DataFormerMock
  class User
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name
  end

  class Course
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name
    field :desc

    has_many :chapters, class_name: "DataFormerMock::Chapter"
    belongs_to :user, class_name: "DataFormerMock::User"

    def read_percent_of_user(user)
      "#{user.name}_percent"
    end
  end

  class Chapter
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name
    field :desc

    belongs_to :course, class_name: "DataFormerMock::Course"
  end
end

DataFormer.class_eval do

  former 'DataFormerMock::Course' do
    brief do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :desc
    end

    logics do
      logic :learned, ->(instance, user){
        percent = instance.read_percent_of_user(user)
        "#{percent}_learned"
      }
    end

    urls do
      url :update, ->(instance, url_helpers){
        url_helpers.course_path(instance)
      }
    end

  end

  former 'DataFormerMock::Chapter' do
    brief do
      field :id, ->(instance) {instance.id.to_s}
      field :name
      field :desc
    end
  end

  former 'DataFormerMock::User' do
    brief do
      field :id, ->(instance) {instance.id.to_s}
      field :name
    end
  end

end


RSpec.describe DataFormer, type: :model do
  before{
    @user     = DataFormerMock::User.create(name: "user_1")
    @course   = DataFormerMock::Course.create(name: "course_name_1", desc: "course_desc_1", user: @user)
    @chapter1 = DataFormerMock::Chapter.create(name: "chapter_name_1", desc: "chapter_desc_1", course: @course)
    @chapter2 = DataFormerMock::Chapter.create(name: "chapter_name_2", desc: "chapter_desc_2", course: @course)
  }

  describe "UndefinedFormerError" do
    it {
      expect{DataFormer.new({}).data}.to raise_error(DataFormerConfig::UndefinedFormerError)
    }
  end

  describe "data method" do
    it{
      data = DataFormer.new(@course).data
      expect(data).to match({})
    }
  end

  describe "brief method" do
    it "不传参数" do
      data_former = DataFormer.new(@course)
      data_former.brief
      data = data_former.data
      expect(data).to match({
        id: @course.id.to_s,
        name: @course.name,
        desc: @course.desc
      })
    end

    it "传参数" do
      data_former = DataFormer.new(@course)
      data_former.brief(id: ->(instance){ instance.id.to_s + " gai"})
      data = data_former.data
      expect(data).to match({
        id: @course.id.to_s + " gai",
        name: @course.name,
        desc: @course.desc
      })
    end
  end

  describe "logic method" do
    it{
      data = DataFormer.new(@course).logic(:learned, @user).data
      expect(data).to match({:learned=>"user_1_percent_learned"})
    }
  end

  describe "relation method" do
    it "没有自定义" do
      data = DataFormer.new(@course).relation(:chapters).relation(:user).data
      expect(data).to match({
        chapters: [
          {id: @chapter1.id.to_s, name: @chapter1.name, desc: @chapter1.desc},
          {id: @chapter2.id.to_s, name: @chapter2.name, desc: @chapter2.desc}
        ],
        user: {
          id: @user.id.to_s, name: @user.name
        }
      })
    end

    it "自定义" do
      data = DataFormer.new(@course).relation(:chapters, ->(chapters){
        chapters.map do |chapter|
          DataFormer.new(chapter).brief(id: ->(c){c.id.to_s + " gai"}).data
        end
      }).data
      expect(data).to match({
        chapters: [
          {id: @chapter1.id.to_s + " gai", name: @chapter1.name, desc: @chapter1.desc},
          {id: @chapter2.id.to_s + " gai", name: @chapter2.name, desc: @chapter2.desc}
        ]
      })
    end
  end

  describe "url method" do
    it{
      data = DataFormer.new(@course).url(:update).data
      expect(data).to match({:update=>"/courses/#{@course.id.to_s}"})
    }
  end
end
