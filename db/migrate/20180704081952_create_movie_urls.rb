class CreateMovieUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :movie_urls do |t|
      t.string :url
      t.references :playlist, foreign_key: true
      t.string :title
      t.string :description
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
