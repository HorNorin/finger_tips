class TranslateLessons < ActiveRecord::Migration
  def self.up
    Lesson.create_translation_table!({
      slug: :string,
      name: :string
    }, {
      migrate_data: true
    })
  end
  
  def self.down
    Lesson.drop_translation_table! migrate_data: true
  end
end
