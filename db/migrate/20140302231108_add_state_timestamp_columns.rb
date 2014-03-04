class AddStateTimestampColumns < ActiveRecord::Migration
  def change
    add_column :notebooks, :submitted_on, :datetime
    add_column :notebooks, :received_on,  :datetime
    add_column :notebooks, :uploaded_on,  :datetime
    add_column :notebooks, :processed_on, :datetime
    add_column :notebooks, :returned_on,  :datetime
    add_column :notebooks, :recycled_on,  :datetime
  end
end
