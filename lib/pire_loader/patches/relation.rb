# frozen_string_literal: true

module PireLoader
  module Patches
    module Relation
      #######################
      # Lazy load interface #
      #######################
      def lazy_load(*args)
        spawn.lazy_load!(*args)
      end

      def lazy_load!(*args) # :nodoc:
        # args.compact_blank!
        args.flatten!

        self.lazy_load_values |= args
        self
      end

      def lazy_load_values
        @values.fetch(:lazy_load, [])
      end

      def lazy_load_values=(value)
        assert_mutability!
        @values[:lazy_load] = value
      end
      #######################
      # Lazy load interface #
      #######################

      ###########################
      # Parent relation methods #
      ###########################
      def parent_relation
        @values.fetch(:parent_relation, nil)
      end

      def parent_relation=(value)
        @values[:parent_relation] = value
      end
      ###########################
      # Parent relation methods #
      ###########################

      ###########################
      # After load methods      #
      ###########################
      def after_load_callback
        @values.fetch(:after_load, nil)
      end

      def after_load(&blk)
        @values[:after_load] = blk
      end
      ###########################
      # After load methods      #
      ###########################

      ### Loading
      def load(*)
        super.tap do
          inject_self
          run_after_load
        end
      end

      def inject_self
        @records.each { |record| record.parent_relation = self } if lazy_load_values.present?
      end

      # This can also modify the @records if the callback
      # returns a new collection!
      def run_after_load
        return unless after_load_callback

        new_records = after_load_callback.call(@records)
        @records = new_records.freeze if new_records.present?
      end
    end
  end
end

ActiveRecord::Relation.prepend(PireLoader::Patches::Relation)
