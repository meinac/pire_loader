# frozen_string_literal: true

module PireLoader
  module Patches
    module Associations
      module SingularAssociation
        def find_target
          return super unless lazy_load?

          PireLoader::Loaders::Singular.preload(self) && target
        end
      end
    end
  end
end

ActiveRecord::Associations::SingularAssociation.prepend(PireLoader::Patches::Associations::SingularAssociation)
