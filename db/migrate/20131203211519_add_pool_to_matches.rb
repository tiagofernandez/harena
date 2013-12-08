class AddPoolToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :pool, :string
  end
end
