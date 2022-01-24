# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module PireLoader
  module Loaders
    class Singular
      def self.preload(association)
        new(association).preload
      end

      def initialize(association)
        @association = association
      end

      def preload
        owner_records.each do |record|
          join_value = record[join_foreign_key]

          record.association(reflection.name).target = associated_records[join_value]
        end
      end

      private

      attr_reader :association

      delegate :reflection, to: :association, private: true
      delegate :foreign_key, :join_foreign_key, to: :reflection, private: true

      def associated_records
        @associated_records ||= association.scope
                                           .except(:limit)
                                           .rewhere(foreign_key => join_values)
                                           .to_a
                                           .index_by(&foreign_key.to_sym)
      end

      def owner_records
        @owner_records ||= association.owner.parent_relation.records
      end

      def join_values
        owner_records.map { |record| record[join_foreign_key] }
      end
    end
  end
end
