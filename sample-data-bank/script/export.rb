File.open 'sample-data-bank/json/teller_ware.json', 'w' do |f|
  f.write ::Finance::TellerWare.all.to_json
end

File.open 'sample-data-bank/json/teller_ware_screen.json', 'w' do |f|
  f.write ::Finance::TellerWareScreen.all.to_json
end

File.open 'sample-data-bank/json/teller_ware_trade.json', 'w' do |f|
  f.write ::Finance::TellerWareTrade.all.to_json
end