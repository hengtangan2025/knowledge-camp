FactoryGirl.define do
  factory :cms_config do
    sequence(:name){|n| "name-#{n}"}
    sequence(:value){|n| "value-#{n} 描述"}
  end
end
