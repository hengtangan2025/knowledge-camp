module Explore
  module ApplicationHelper
    def tutorials_mock
      @tutorials = [
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-1',
          :img => asset_path('/assets/sample/shao.jpg'),
          :title => '勺工基本技法入门',
          :desc => '勺工是中式烹调特有的一项技术，是中式烹调用火和施艺的独特功夫。运用勺工技艺，调节和控制火候是每个厨师必备的基本功之一。'
        }),
        OpenStruct.new({
          :net => KnowledgeNetStore::Net.first,
          :id => 'sample-2',
          :img => asset_path('/assets/sample/dao.jpg'),
          :title => '刀工基本技法入门',
          :desc => '刀工就是根据烹调与食用的需要，将各种原料加工成一定形状，使之成为组配菜肴所需要的基本形体的操作技术。'
        }),
      ]
    end
  end
end