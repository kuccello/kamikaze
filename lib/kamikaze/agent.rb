require ~'request'

module SoldierOfCode
  module Kamikaze

    class Order

      attr_accessor :delay, :method, :url, :variablility, :limit

      def initialize
        @limit = 1
        @delay = 5000
        @method = :get
        @url = "http://google.com"
        @variablility = 0
      end

    end

    class Agent

      attr_accessor :name, :location, :request_pool, :activity_frequency, :user_agent, :status

      def initialize(outfit={})

        @name = "Unnammed"
        @location = "localhost"
        @request_pool = []
        @user_agent = "Soldier Of Code (Kamikaze, TORA TORA TORA) Version/#{$KAMIKAZE_VERSION || '0.1'}"
        @logger = $stdout
        @start_at = Time.new.to_i
        @status = 'working'
        self.dress_up(outfit)
      end

      def dress_up(outfit={})

        @start_at = outfit[:start_at] || Time.new.to_i
        @logger = outfit[:logger] || $stdout
        @name = outfit[:name] || "Unnamed"
        @location = outfit[:location] || "localhost"
        @user_agent = outfit[:user_agent] || "Soldier Of Code (Kamikaze, TORA TORA TORA) Version/#{$KAMIKAZE_VERSION || '0.1'}"
      end

      def issue_orders(orders=[])

        orders.each do |order|

          for i in 1..order.limit

            execute_at = @start_at + ((order.delay * i) + rand(order.variablility) )
            puts "#{__FILE__}:#{__LINE__} #{__method__} EXE: #{Time.at(execute_at)}"
            @request_pool << Request.new(self, order.url, execute_at, @logger)
          end
        end

      end

    end
  end
end
