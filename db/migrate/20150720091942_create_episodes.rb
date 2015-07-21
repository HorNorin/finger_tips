class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :title
      t.text :description
      t.string :image
      t.string :youtube_url

      t.timestamps null: false
    end
  end
end
