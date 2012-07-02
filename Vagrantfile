Vagrant::Config.run do |config|
  config.vm.box = "heroku"
  config.vm.box_url = "http://dl.dropbox.com/u/1906634/heroku.box"

  config.vm.network :hostonly, "33.33.33.10"

  # DB Setup
  config.vm.provision :shell, :inline => "createdb -U postgres agileconf"
  # For Taps
  config.vm.provision :shell, :inline => "apt-get install libsqlite3-dev"
  # Development gems
  config.vm.provision :shell, :inline => "gem install shotgun"
  config.vm.provision :shell, :inline => "gem install heroku"
  config.vm.provision :shell, :inline => "gem install sqlite3"
  config.vm.provision :shell, :inline => "gem install taps"
  config.vm.provision :shell, :inline => "gem install pg"
  config.vm.provision :shell, :inline => "gem install capybara"
  config.vm.provision :shell, :inline => "gem install rspec"
  # For scraping
  config.vm.provision :shell, :inline => "gem install mechanize"
end
