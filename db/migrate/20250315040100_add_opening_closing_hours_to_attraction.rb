class AddOpeningClosingHoursToAttraction < ActiveRecord::Migration[7.1]
  def change
    add_column :attractions, :opening_hour, :time
    add_column :attractions, :closing_hour, :time
  end
end
