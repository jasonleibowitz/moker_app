class RenameCommentColumnReviews < ActiveRecord::Migration
  def change
    change_table :reviews do |t|
      t.rename :comment, :tip
    end
  end
end
