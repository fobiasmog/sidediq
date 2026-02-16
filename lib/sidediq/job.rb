require 'ffi-rzmq'
require 'json'
require 'active_job'

module Sidediq
    class Job
        class << self
            def perform(job_data, at: nil)
                context = ZMQ::Context.new
                socket  = context.socket(ZMQ::PUSH)
                socket.connect("tcp://127.0.0.1:5555")

                res = socket.send_string(JSON.dump(job_data), ZMQ::DONTWAIT)
                puts "Client received: #{res}"
                socket.close
                context.terminate
            end

            def execute(...)
                ActiveJob::Base.execute(...)
            end
        end
    end
end
