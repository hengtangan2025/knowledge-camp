module BankManage
  module TestPapersHelper
    def english_choices
      @english_choices ||= ('A'..'Z').to_a
    end
  end
end
