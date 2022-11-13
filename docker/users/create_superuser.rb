username = ENV['SUPERUSER_USERNAME']
password = ENV['SUPERUSER_PASSWORD']
email = ENV['SUPERUSER_EMAIL']

account = Account.create!(username: 'username')
user = User.create!(email: 'email', password: 'password', account: account)
user.confirm
account.save!
user.save!