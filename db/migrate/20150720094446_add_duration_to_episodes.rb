class AddDurationToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :duration, :integer, default: 0
  end
end
