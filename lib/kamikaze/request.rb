require 'rubygems'
#require 'mechanize'
require 'digest/md5'
require 'patron'

module SoldierOfCode
  module Kamikaze
    class Request
      attr_accessor :triggered_at, :created_at, :execute_at, :url, :response_code, :content_hash, :start_unix_stamp, :end_unix_stamp, :duration, :agent, :complete, :error

      def initialize(agent, url, execute_at, logger=$stdout)

        # I guess we should thread it off here?...
        #@thread = Thread.start(self){|r| r.activate}
        #@thread.join
        #self.start{self.activate}
        @thread = Thread.new("request-#{@created_at}") do |my_thread|
          Thread.current[:name] = "#{my_thread}"

          @agent = agent
          @url = url
          @start_unix_stamp = 0
          @start_unix_usec = 0
          @end_unix_stamp = 0
          @end_unix_usec = 0
          @triggered_at = 0
          @created_at = Time.new.to_i
          @execute_at = execute_at
          @complete = false
          @logger = logger
          @error = false

          puts "#{__FILE__}:#{__LINE__} #{__method__} #{@agent} EXECUTE AT #{Time.at(@execute_at)}"
          while (Time.new.to_i < @execute_at) do
            sleep(1)
          end
          puts "#{@agent} TIME NOW #{Time.new} < #{Time.at(@execute_at)}"
          puts "#{!(Time.new.to_i < @execute_at)} ?? go?"

          @triggered_at = Time.new.to_i
          #@logger.puts "[#{@agent.name}] - Request triggered at #{@triggered_at} - activated."

          sess = Patron::Session.new
          sess.timeout = 30

          sess.headers['User-Agent'] = @agent.user_agent

          start_timer
          begin
            resp = sess.get(@url)
            end_timer
            @content_hash = Digest::MD5.hexdigest(resp.body)
            @response_code = resp.status
          rescue => e
            end_timer
            @error = true
            @content_hash = '-'
          end
          @complete = true
          log_self
        end
      end


      private
      def log_self
        @logger.puts "#{@agent.name},#{@error?'FAIL':'PASS'},#{@response_code},#{@url},#{@content_hash},#{@duration},#{@start_unix_stamp},#{@end_unix_stamp},#{@triggered_at},#{@execute_at},#{@created_at},#{@agent.location}"
      end

      def start_timer
        time = Time.new
        @start_unix_stamp = time.to_i
        @start_unix_usec = time.usec
      end

      def end_timer
        time = Time.new
        @end_unix_stamp = time.to_i
        @end_unix_usec = time.usec
        @duration = "#{@end_unix_stamp}.#{@end_unix_usec}".to_f - "#{@start_unix_stamp}.#{@start_unix_usec}".to_f
      end
    end
  end
end
