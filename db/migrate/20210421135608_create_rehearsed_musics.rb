class CreateRehearsedMusics < ActiveRecord::Migration[6.1]
  def change
    create_table :rehearsed_musics do |t|
      t.references :practice_session, null: false, foreign_key: true
      t.references :music, null: false, foreign_key: true

      t.timestamps
    end
  end
end
