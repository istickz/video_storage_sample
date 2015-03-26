class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :file
      t.string :tmp_path
      t.string :quality
      t.string :duration
      t.boolean :status, default: 0

      t.timestamps null: false
    end
  end
end
