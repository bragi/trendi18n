class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table ActiveRecord::Base.pluralize_table_names ? :translations : :translation do |t|
      t.string :locale, :null => false, :limit => 6
      t.string :key, :null => false
      t.string :scope
      t.text :default, :null => false
      t.text :translation
      t.text :zero
      t.text :one
      t.text :many
      t.text :few
      t.string :state, :null => false
      t.timestamps
    end
    add_index :translations, [:locale, :key, :scope], :unique => true
  end

  def self.down
    drop_table ActiveRecord::Base.pluralize_table_names ? :translations : :translation
  end
end