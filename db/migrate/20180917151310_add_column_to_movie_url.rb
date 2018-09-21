class AddColumnToMovieUrl < ActiveRecord::Migration[5.2]
  def change
    add_column :movie_urls, :ytid, :string
  end
end
