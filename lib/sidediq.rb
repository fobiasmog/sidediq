require "sidediq/version"
require "sidediq/railtie"
require "active_job"
require "sidediq/job"

module Sidediq
    class << self
        def enqueue(job)
            serialized = job.serialize
            Sidediq::Job.perform(serialized)
        end
    end

    module Serializer
        extend ActiveSupport::Concern

        module ClassMethods
            def serializer(klass=nil, &block)
                self.serializer_block = block if block_given?
                self.serializer_class = klass
            end
            def deserializer(klass=nil)
                self.deserializer_class = klass
            end
        end

        included do
            class_attribute :serializer_block
            class_attribute :serializer_class
            class_attribute :deserializer_class
        end
    end
end


module ActiveJob
    class Base
        include Sidediq::Serializer

        def initialize(...)
            @serializer_block = self.class.serializer_block
            @serializer_class = self.class.serializer_class
            @deserializer_class = self.class.deserializer_class or self.class.serializer_class
            super(...)
        end
    end

    module Core
        private
            def serialize_arguments(args)
                case [serializer_block, serializer_class]
                when [true, true]
                    message_data = serializer_block.call(*args)
                    serializer_class.encode(
                        serializer_class.new(message_data)
                    )
                when [true, false]
                    serializer_block.call(*args)
                when [false, true]
                    serializer_class.encode(
                        serializer_class.new(*args)
                    )
                else
                    raise NotImplementedError
                end
            end

            def deserialize_arguments(arguments)
                raise NotImplementedError unless deserializer_class
                [
                    Hash.ruby2_keywords_hash(
                        deserializer_class.decode(arguments).to_hash
                    )
                ]
            end
    end

    module QueueAdapters
        class SidediqAdapter
            def enqueue(job)
                Sidediq.enqueue(job)
            end

            def enqueue_at(job, timestamp)
                raise NotImplementedError, "Sidediq does not support scheduled jobs"
            end
        end
    end
end
