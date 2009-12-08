# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091208191434) do

  create_table "translations", :force => true do |t|
    t.string   "locale",      :limit => 6, :null => false
    t.string   "key",                      :null => false
    t.string   "scope"
    t.text     "default",                  :null => false
    t.text     "translation"
    t.text     "zero"
    t.text     "one"
    t.text     "many"
    t.text     "few"
    t.string   "state",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "translations", ["locale", "key", "scope"], :name => "index_translations_on_locale_and_key_and_scope", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
