class RemoveTipsColumnFromReviews < ActiveRecord::Migration
  def change
    remove_column :reviews, :tip
  end
end
