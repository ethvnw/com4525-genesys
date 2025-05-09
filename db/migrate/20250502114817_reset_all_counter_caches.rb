class ResetAllCounterCaches < ActiveRecord::Migration[7.0]
  def change
    Rake::Task['db:set_counter_caches'].invoke
  end
end
