class RemoveLastPlayedFromMusics < ActiveRecord::Migration[6.1]
  def change
    remove_column :musics, :last_played, :datetime
  end
end
