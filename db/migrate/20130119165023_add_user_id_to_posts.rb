class AddUserIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :user_id , :integer ,:references=>"users"
    # add_column :posts, :user_id, :reference
  end
end
