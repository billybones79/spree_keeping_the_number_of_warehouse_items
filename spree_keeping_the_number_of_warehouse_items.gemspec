# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_keeping_the_number_of_warehouse_items'
  s.version     = '3.0.81'

  s.summary     = 'Adds a warehouse_count and on_hold count to products'
  s.description = 'Adds a warehouse_count and on_hold count to products for an easier integration with external inventory manager'
  s.required_ruby_version = '>= 2.0.0'

  s.author    = 'Alexandre DT'
  s.email     = 'aduperre@lawebshop.ca'
  # s.homepage  = 'http://www.spreecommerce.com'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'activerecord-delay_touching', '~> 1.0.1'
  s.add_dependency 'sidekiq'
  s.add_dependency 'redis-rails'
  s.add_dependency 'smarter_csv'



  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 5.0.0.beta1'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'sidekiq'

end
