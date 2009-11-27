require 'rubygems'
require 'dirge'
require ~'kamikaze/agent'
require ~'kamikaze/request'

module SoldierOfCode
  module Kamikaze
    class ToraToraTora

      def initialize
        self.go
      end

      def go
        puts "#{__FILE__}:#{__LINE__} #{__method__} Starting"
        user_agents = ["Mozilla/5.0 (X11; U; Linux i686; it-IT; rv:1.9.0.2) Gecko/2008092313 Ubuntu/9.25 (jaunty) Firefox/3.8"]
        orders = []
#        orders << Order.new
        order = Order.new
        order.limit = 2
        order.url = "http://developer.openapps.com"
        order.delay = 10 # 10 sec
        order.variablility = 5 # 5 sec variable
        orders << order

        File.open(~"#{Time.new.to_i}.txt", 'w') do |f|
          f.puts "@agent.name,PASS/FAIL,@response_code,@url,@content_hash,@duration,@start_unix_stamp,@end_unix_stamp,@triggered_at,@execute_at,@created_at,@agent.location"

          outfit = {:name=>"Experimental Agent", :logger=>f, :user_agent=>user_agents.first}

          agent = Agent.new(outfit)

          agent.issue_orders(orders)

          flag = true
          while flag
            flag = false
            agent.request_pool.each do |req|
              flag = true if !req.complete
            end
          end
        end
        puts "#{__FILE__}:#{__LINE__} #{__method__} Done."
      end

    end
  end
end

SoldierOfCode::Kamikaze::ToraToraTora.new
