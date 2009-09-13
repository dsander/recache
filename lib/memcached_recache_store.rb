# The RecacheStore is an ActiveRecord model definition used for storing cache data.
# To create the recache_stores table run the recache_migration generator 
#  ruby script/generate recache
#  rake db:migrate
require 'ostruct'


  class MemcachedRecacheStore
    
    def initialize()
      if defined?(RAILS_ENV)
        @m = Rails.cache
      else
        @m = MemCache.new 'localhost'
      end
    end
    
    def find(all, options)
      if defined? RAILS_ENV
        @m.read(options[:conditions].last)
      else
        @m.get(options[:conditions].last)
      end
    end
    
    def delete_all(options)
      @m.delete(options.last)
    end
    
    def create(options)
      data = OpenStruct.new
      data.created_at = options[:created_at]
      data.data = options[:data]
      data.cached_until = options[:cached_until]
      if defined? RAILS_ENV
        @m.write(options[:request_hash], data)
      else
        @m.set(options[:request_hash], data)
      end
    end
  end
