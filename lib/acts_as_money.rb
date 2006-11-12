require 'money'

module CollectiveIdea #:nodoc:
  module Acts
    module Money #:nodoc:
      def self.included(base) #:nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        def money(name, options = {})
          options = {:cents => :cents, :currency => :currency}.merge(options)
          mapping = [[options[:cents].to_s, 'cents']]
          mapping << [options[:currency].to_s, 'currency'] if options[:currency]
          
          composed_of name, :class_name => 'Money', :allow_nil => true, :mapping => mapping do |m|
            m.to_money
          end
        end
      end
    end
  end
end

class Money
  def -@
    Money.new(-@cents, @currency)
  end
end