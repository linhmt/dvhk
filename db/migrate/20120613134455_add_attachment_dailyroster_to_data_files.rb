class AddAttachmentDailyrosterToDataFiles < ActiveRecord::Migration
  def self.up
    add_column :data_files, :dailyroster_file_name, :string
    add_column :data_files, :dailyroster_content_type, :string
    add_column :data_files, :dailyroster_file_size, :integer
    add_column :data_files, :dailyroster_updated_at, :datetime
    add_column :data_files, :is_arrival, :boolean
  end

  def self.down
    remove_column :data_files, :dailyroster_file_name
    remove_column :data_files, :dailyroster_content_type
    remove_column :data_files, :dailyroster_file_size
    remove_column :data_files, :dailyroster_updated_at
    remove_column :data_files, :is_arrival
  end
end
