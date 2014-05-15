class AddPictureToTips < ActiveRecord::Migration
  def self.up
    add_attachment :tips, :picture
  end

  def self.down
    remove_attachment :tips, :picture
  end
end
