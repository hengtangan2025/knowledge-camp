class Manager::Finance::TellerWaresController < ApplicationController
  layout "new_version_manager"

  def index
    @page_name = "manager_finance_teller_wares"
    wares = ::Finance::TellerWare.page params[:page]
    data = wares.map {|x|
      DataFormer.new(x).data
    }

    @component_data = {
      wares: data,
      paginate: DataFormer.paginate_data(wares)
    }

    render "/mockup/page"
  end

  # # 从 json 创建 ::Finance::TellerWare
  # def _read_json_data
  #   string = File.read '/web/ben7th/temp/0406/flow.json'
  #   # render text: string
  #   data = JSON.parse string
  #   data = data.map {|x|
  #     x.delete('_id')
  #     x.delete('created_at')
  #     x.delete('updated_at')
  #     x
  #   }

  #   data = data.map do |x|
  #     ware = ::Finance::TellerWare.new(x)
  #     ware.creator = User.first
  #     ware.save
  #   end

  #   render json: data[0]
  # end
end
