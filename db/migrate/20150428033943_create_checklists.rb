class CreateChecklists < ActiveRecord::Migration
  def change
    create_table :checklists do |t|
      t.string :location
      t.string :token

      t.timestamps
    end
  end
end
