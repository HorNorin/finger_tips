class AddEpisodesCountToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :episodes_count, :integer, default: 0
  end
end
