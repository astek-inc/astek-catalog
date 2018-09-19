namespace :db do

  require 'open3'

  desc 'Writes the contents of a database dump to a file on S3'
  task :backup => :environment do

    filename = "#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.dump"

    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_dump --host #{host} --verbose --clean --no-owner --no-acl --format=c #{db}"
    end
    puts cmd
    backup, status = Open3.capture2(cmd)

    directory = storage.directories.get('astek-catalog-database-backup')
    uploaded = directory.files.create(
        key: filename,
        body: backup,
        public: true
    )

    puts 'Uploaded database backup file '+filename+' to S3'

  end

  private

  def storage
    Fog::Storage.new(
        provider: 'AWS',
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        region: 'us-west-2',
        path_style: true
    )
  end

  def with_config
    yield Rails.application.class.parent_name.underscore,
        ActiveRecord::Base.connection_config[:host],
        ActiveRecord::Base.connection_config[:database],
        ActiveRecord::Base.connection_config[:username]
  end

end
