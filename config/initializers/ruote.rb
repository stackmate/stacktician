require 'rufus-json/automatic'
require 'ruote'
require 'ruote/storage/fs_storage'
require 'stackmate'
 
#
# set up ruote storage
 
sequel = Sequel.connect(
      'jdbc:mysql://localhost:3306/stacktician?user=stacktician&password=stacktician')

Ruote::Sequel.create_table(sequel, false)

#RUOTE_STORAGE = 
#  Ruote::Dashboard.new(
#       Ruote::Worker.new(
#               Ruote::Sequel::Storage.new(sequel)))
 
#
# set up ruote dashboard
 
RUOTE = Ruote::Dashboard.new(Ruote::Worker.new(Ruote::Sequel::Storage.new(sequel)))
# RUOTE = if defined?(Rake)
#   #
#   # do not start a ruote worker in a rake task
#   #
#   p "aaaa"
#   Ruote::Dashboard.new(Ruote::Sequel::Storage.new(sequel))
# else
#   #
#   # start a worker
#   #
#   p "bbbb"
#   Ruote::Dashboard.new(Ruote::Worker.new(Ruote::Sequel::Storage.new(sequel)))
# end

RUOTE.noisy = true
 
