class SetupAdminUser < ActiveRecord::Migration
  def self.up
    user = User.new
    user.email = ENV['ADMIN_EMAIL']
    user.password = ENV['ADMIN_PASSWORD']
    user.save
    user.add_role 'admin'
  end

  def self.down
    # raise ActiveRecord::IrreversibleMigration
    user = User.find_by(email: ENV['ADMIN_EMAIL'])
    puts user
    user.destroy!
  end
end
