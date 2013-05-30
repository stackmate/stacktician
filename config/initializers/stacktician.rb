#configure stackmate to use the NoOp resources if in demo mode
StackMate.configure('NOOP') if ENV['DEMO_MODE'] == 'NOOP'

