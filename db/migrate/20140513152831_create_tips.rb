class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.references :user
      t.string :comment
      t.timestamps
    end
  end
end
