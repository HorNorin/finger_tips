class TranslateEpisodes < ActiveRecord::Migration
  def self.up
    Episode.create_translation_table!({
      slug: :string,
      title: :string,
      description: :text
    }, {
      migrate_data: true
    })
  end
  
  def self.down
    Episode.drop_translation_table! migrate_data: true
  end
end
