module Mockup::ManagerBankMethods
  include Mockup::SampleData

  def manager_bank_page
    @current_func = params[:page]
    @page_name = "manager_bank_#{params[:page]}"
    @component_data = case @page_name
      when 'manager_bank_teller_wares'
        get_manager_bank_teller_wares_data
      end
    render layout: 'mockup_manager', template: 'mockup/page'
  end

  def get_manager_bank_teller_wares_data
    SAMPLE_TELLER_WARES_DATA.map { |x|
      x.merge(
        manage_url: mockup_manager_bank_url(page: 'teller_ware_show')
      )
    }
  end
end