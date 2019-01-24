# lignes très pratiques qui appellent les gems du Gemfile. On verra plus tard comment s'en servir ;)
require 'bundler'
Bundler.require

# lignes qui appellent les fichiers lib/user.rb et lib/event.rb
# comme ça, tu peux faire User.new dans ce fichier d'application. Top.
$:.unshift File.expand_path("./../lib/app", __FILE__)
require 'scrapper'

s = Scrapper.new
#s.save_as_JSON
#s.save_as_csv
s.gsheet

#require_relative 'scrapper'




#require_relative 'lib/event'


# Open bar pour tester ton application. Tous les fichiers importants sont chargés
# Tu peux faire User.new, Event.new, binding.pry, User.all, etc etc
