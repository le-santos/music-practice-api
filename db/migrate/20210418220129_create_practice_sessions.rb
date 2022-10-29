class CreatePracticeSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :practice_sessions do |t|
      t.string :goals
      t.string :notes
      t.string :attachments
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
