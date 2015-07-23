class AddLessonIdToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :lesson_id, :integer
  end
end
