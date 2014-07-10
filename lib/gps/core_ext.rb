# Be friendly outside of Rails / Orders...

unless Object.const_defined?('Rails')
  module Rails
    def self.env
      ActiveSupport::StringInquirer.new 'test'
    end
  end
end

# lib/core/hash/dottable.rb
unless Hash.new.respond_to? :dottable!
  module Core
    module Hash
      module Dottable
        def self.included(base)
          base.extend(ClassMethods)
        end

        def dottable!
          self.class.extend_nodes(self)
        end

        module ClassMethods
          def extend_nodes(node)
            node
            case node
              when Array
                node.each do |v|
                  extend_nodes(v)
                end
              when Hash
                node.extend(::Core::Hash::Dottable::InstanceMethods)
                node.each do |k, v|
                  extend_nodes(v)
                end
            end
          end
        end

        # There definitely is code duplication in this class, but removing the code duplication
        # made it around 25% slower, and this code is used all over the place, so I've (Richie)
        # left it in.
        #
        # hash = { 'a' => 1 }.dottable!
        # Benchmark.realtime do
        #   10_000_000.times do
        #     hash.a
        #   end
        # end
        module InstanceMethods
          def respond_to?(sym, include_private=false)
            has_key?(sym) || has_key?(sym.to_s) || super
          end

          def id
            sym      = :id
            sym_to_s = sym.to_s
            if has_key?(sym_to_s)
              self[sym_to_s]
            elsif has_key?(sym)
              self[sym]
            else
              super
            end
          end

          def method_missing(sym, *args, &block)
            sym_to_s = sym.to_s
            if has_key?(sym_to_s)
              self[sym_to_s]
            elsif has_key?(sym)
              self[sym]
            else
              super
            end
          end
        end
      end
    end
  end

  Hash.send :include, Core::Hash::Dottable
end
