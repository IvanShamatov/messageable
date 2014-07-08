require 'singleton'
require 'bunny'
require 'json'



module Messageable

  # Including hook
  def self.included(base)
    attr_accessor :queue
    base.extend(ClassMethods)
  end

  # publish itself to queue
  def _publish
    puts("pushing message: #{self.to_json} to queue #{@queue}")
    AMQPCli.instance.push(self.to_json, @queue)
  end


  module ClassMethods
    # Example:
    # class Event < ActiveRecord::Base
    #   include Messagable
    #   publish_after :create, queue: ""#, exchange: {}
    # end

    def publish_after(actions, config)
      after_initialize do 
        self.queue = config[:queue]
      end
      if actions.include?(:all)
        after_update :_publish
      end
    end
  end


  class AMQPCli
    include Singleton

    attr_accessor :connection

    def initialize
      @connection = Bunny.new
      @connection.start
    end

    def channel

      @channel ||= connection.create_channel
    end

    def push(message, queue)
      channel.queue(queue).publish(message)
    end

    at_exit do
      self.instance.connection.close
      puts "Closing connection"
    end

  end
end
