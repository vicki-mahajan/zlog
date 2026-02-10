class RemoveSlugFromPosts < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :slug, :string
  end
end
