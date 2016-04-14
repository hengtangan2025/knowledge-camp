class Manager::Finance::TellerWaresController < ApplicationController
  layout "new_version_manager"

  def index
    @page_name = "manager_finance_teller_wares"
    wares = ::Finance::TellerWare.order_by(number: :asc).page(params[:page]).per(15)
    data = wares.map {|x|
      DataFormer.new(x)
        .logic(:business_kind_str)
        .url(:preview_url)
        .url(:design_url)
        .data
    }

    @component_data = {
      wares: data,
      paginate: DataFormer.paginate_data(wares),
      filters: {
        kinds: ::Finance::TellerWare::KINDS
      }
    }

    render "/mockup/page"
  end

  def preview
    ware = ::Finance::TellerWare.where(number: params[:number]).first

    @page_name = "manager_finance_teller_ware_preview"
    @component_data = DataFormer.new(ware)
      .logic(:actions)
      .data
    render "/mockup/page", layout: 'finance/preview'
  end

  def screens
    @page_name = "manager_finance_teller_ware_screens"

    screens = ::Finance::TellerWareScreen.page(params[:page]).per(15)
    data = screens.map {|x|
      DataFormer.new(x)
        .data
    }

    @component_data = {
      screens: data,
      paginate: DataFormer.paginate_data(screens)
    }

    render "/mockup/page"
  end

  def trades
    @page_name = "manager_finance_teller_ware_trades"

    trades = ::Finance::TellerWareTrade.page(params[:page]).per(15)
    data = trades.map {|x|
      DataFormer.new(x)
        .data
    }

    @component_data = {
      trades: data,
      paginate: DataFormer.paginate_data(trades),
    }

    render "/mockup/page"
  end

  def trade
    trade = ::Finance::TellerWareTrade.where(number: params[:number]).first
    render json: DataFormer.new(trade).logic(:all_hmdms).data
  end

  def hmdm
    screen = ::Finance::TellerWareScreen.where(hmdm: params[:hmdm]).first
    data = DataFormer.new(screen).data.merge({
      xxdm_url: xxdm_manager_finance_teller_wares_path
    })
    render json: data 
  end

  def xxdm
    xxmxs = ::Finance::TellerWareXxmx.where(xxdm: params[:xxdm])
    render json: xxmxs.map {|x|
      DataFormer.new(x).data
    }
  end

  def design
    ware = ::Finance::TellerWare.find params[:id]
    data = DataFormer.new(ware)
      .logic(:actions)
      .url(:update_url)
      .url(:design_update_url)
      .url(:preview_url)
      .data

    @page_name = "manager_finance_teller_ware_design"
    @component_data = {
      ware: data,
    }

    render "/mockup/page", layout: 'finance/design'
  end

  def update
    ware = ::Finance::TellerWare.find params[:id]

    ware.name           = params[:ware][:name]
    ware.number         = params[:ware][:number]
    ware.desc           = params[:ware][:desc]
    ware.business_kind  = params[:ware][:business_kind]
    ware.editor_memo    = params[:ware][:editor_memo]

    ware.save

    render json: {}
  end

  def design_update
    ware = ::Finance::TellerWare.find params[:id]
    ware.actions = params[:actions]
    ware.save

    render json: {}
  end

  # # 从 json 创建 ::Finance::TellerWareXxmx
  # def _read_xxmx_json_data
  #   file = '/web/ben7th/bank-logic/xxmx.json'
  #   arr = JSON.parse File.read file
  #   arr.each do |x|
  #     ::Finance::TellerWareXxmx.create(x)
  #   end
  #   render json: arr
  # end

  # # 从 json 创建 ::Finance::TellerWareTrade
  # def _read_trades_json_data
  #   arr = Dir['/web/ben7th/operation-flow-editor/progress-data/export/*.json']
  #   arr = arr.map {|f|
  #     number = f.match(/(\d+)\.json/)[1]
  #     trades = JSON.parse(File.read f)
  #     trades
  #       .map {|t|
  #         {
  #           number: number
  #         }.merge(t)
  #       }
  #       .map {|t|
  #         input_screen_hmdms = (t['input_screens'] || []).map {|x| x['hmdm']}
  #         t.delete('input_screens')
  #         t = t.merge input_screen_hmdms: input_screen_hmdms

  #         if t['response_screen']
  #           response_screen_hmdm = t['response_screen']['hmdm']
  #           t.delete('response_screen')
  #           t = t.merge response_screen_hmdm: response_screen_hmdm
  #         end

  #         if t['compound_screen']
  #           compound_screen_hmdm = t['compound_screen']['hmdm']
  #           t.delete('compound_screen')
  #           t = t.merge response_screen_hmdm: compound_screen_hmdm
  #         end

  #         t
  #       }
  #   }.flatten

  #   arr.each do |trade|
  #     t = ::Finance::TellerWareTrade.new trade
  #     t.save
  #   end

  #   render json: arr
  # end

  # # 从 json 创建 ::Finance::TellerWareScreen
  # def _read_screens_json_data
  #   arr = Dir['/web/ben7th/operation-flow-editor/progress-data/export/*.json']
  #   arr = arr.map {|f|
  #     JSON.parse(File.read f)
  #       .map {|jy|
  #         screens = jy['input_screens'] || []
  #         screens.push jy['response_screen']
  #         screens.push jy['compound_screen']
  #         screens.compact!
  #       }
  #       .flatten
  #   }
  #   res = arr.each do |screens|
  #     screens.each do |screen|
  #       tws = ::Finance::TellerWareScreen.new({
  #         hmdm: screen['hmdm'],
  #         zds: screen['zds']  
  #       })
  #       tws.save
  #     end
  #   end

  #   render json: res
  # end

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
