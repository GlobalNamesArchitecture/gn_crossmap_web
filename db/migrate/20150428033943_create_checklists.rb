class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :filename
      t.string :token

      t.timestamps, null: false
    end
  end
end
