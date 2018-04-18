class CreateTableDailyExchangeRates < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_exchange_rates do |t|
      t.integer :date
      t.integer :value
    end
  end
end
