require 'rufus-json/automatic'
require 'ruote'
require 'ruote/storage/fs_storage'
 
#
# set up ruote storage
 
RUOTE_STORAGE = 
  Ruote::Dashboard.new(
       Ruote::Worker.new(
               Ruote::FsStorage.new('ruote_work')))
 
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
 
