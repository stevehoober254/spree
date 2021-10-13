class AddMetadataToSpreeOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_orders, :public_metadata, :text
    add_column :spree_orders, :private_metadata, :text
  end
end
