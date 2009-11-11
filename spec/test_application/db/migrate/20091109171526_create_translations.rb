class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table ActiveRecord::Base.pluralize_table_names ? :translations : :translation do |t|
      t.string :locale
      t.string :key
      t.string :scope
      t.text :default
      t.text :translation
      t.text :zero
      t.text :one
      t.text :many
      t.text :few
      t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table ActiveRecord::Base.pluralize_table_names ? :translations : :translation
  end
end