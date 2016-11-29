# frozen_string_literal: true

# Migration to create crossmaps table
class CreateCrossmaps < ActiveRecord::Migration
  def change
    create_table :crossmaps do |t|
      t.string :filename
      t.string :input
      t.string :output
      t.string :token
      t.integer :data_source_id
      t.string :col_sep
      t.boolean :skip_original, default: false
      t.string :status, default: :init
      t.jsonb :params
      t.jsonb :input_sample
      t.jsonb :stats

      t.timestamps null: false
    end
  end
end
