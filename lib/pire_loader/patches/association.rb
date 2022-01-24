# frozen_string_literal: true

module PireLoader
  module Patches
    module Association
      def lazy_load?
        owner.lazy_load?(reflection.name)
      end
    end
  end
end

ActiveRecord::Associations::Association.prepend(PireLoader::Patches::Association)
