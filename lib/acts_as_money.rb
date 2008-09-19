require 'money'

module CollectiveIdea #:nodoc:
  module Acts
    module Money #:nodoc:
      def self.included(base) #:nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        
        def default_currency
          'USD'
        end
        
        def money(name, options = {})
          options = {:cents => "#{name}_in_cents".to_sym, :currency => default_currency}.merge(options)
          mapping = [[options[:cents].to_s, 'cents']]
          mapping << [options[:currency].to_s, 'currency'] if options[:currency]
          
          composed_of name, :class_name => 'Money', :allow_nil => true, :mapping => mapping,
            :converter => lambda {|m| m.to_money }
        end
      end
    end
  end
end

class Money
  cattr_accessor :zero
  
  def -@
    Money.new(-@cents, @currency)
  end
  
  def blank?
    zero?
  end
  
  def format_with_zero(*rules)
    rules = rules.flatten
    options = {}
    options.update rules.pop if rules.last.is_a? Hash
    
    if cents == 0
      if options[:zero]
        options[:zero]
      elsif self.class.zero
        self.class.zero
      else
        format = "$0"
        format << ".00" unless rules.include?(:no_cents)
        format
      end
    else
      format_with_free(rules)
    end
  end
  alias_method :format_with_free, :format
  alias_method :format, :format_with_zero 
  
  def dollars
    to_s.to_f
  end
end  