FactoryGirl.define do
  factory :course, class: KcCourses::Course do
    name "课程1"
    desc "课程1 描述"
    association :creator, factory: :user
  end
end
