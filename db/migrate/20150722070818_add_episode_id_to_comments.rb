class AddEpisodeIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :episode_id, :integer
  end
end
