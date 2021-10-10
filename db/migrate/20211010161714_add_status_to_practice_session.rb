class AddStatusToPracticeSession < ActiveRecord::Migration[6.1]
  def change
    add_column :practice_sessions, :status, :integer, default: 0
  end
end
