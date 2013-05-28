#configure stackmate to use the NoOp resources if in demo mode
StackMate.configure('NOOP') if ENV['DEMO_MODE'] == 'NOOP'

#configure the wait condition base url (used by the WaitHandle participant)
Stacktician.configure(:wait_condition_base_url, 'http://localhost:3000/waitcondition/')
