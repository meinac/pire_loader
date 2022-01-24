# frozen_string_literal: true

module PireLoader
  module Patches
    module Base
      def self.prepended(base)
        base.attr_accessor :parent_relation
      end

      def lazy_load?(association)
        return unless parent_relation

        parent_relation.lazy_load_values.include?(association)
      end
    end
  end
end

ActiveRecord::Base.prepend(PireLoader::Patches::Base)
