class RemovePdfColumnFromPages < ActiveRecord::Migration
  def change
    remove_column :pages, :pdf
  end
end
