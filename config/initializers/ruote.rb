require 'rufus-json/automatic'
require 'ruote'
require 'ruote/storage/fs_storage'
require 'stackmate'
 
#
# set up ruote storage
 
sequel = Sequel.connect(
      'jdbc:mysql://localhost:3306/stacktician?user=stacktician&password=stacktician')

Ruote::Sequel.create_table(sequel, false)

RUOTE_STORAGE = 
  Ruote::Dashboard.new(
       Ruote::Worker.new(
               Ruote::Sequel::Storage.new(sequel)))
 
#
# set up ruote dashboard
 
RUOTE = if defined?(Rake)
  #
  # do not start a ruote worker in a rake task
  #
  Ruote::Dashboard.new(RUOTE_STORAGE)
else
  #
  # start a worker
  #
  Ruote::Dashboard.new(Ruote::Worker.new(RUOTE_STORAGE))
end

RUOTE.noisy = true
 
