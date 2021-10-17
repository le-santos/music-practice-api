class AddUserRefToPracticeSessions < ActiveRecord::Migration[6.1]
  def change
    add_reference :practice_sessions, :user, null: false, foreign_key: true
  end
end
