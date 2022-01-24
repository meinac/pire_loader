# frozen_string_literal: true

module PireLoader
  module Patches
    module Querying
      delegate :lazy_load, :lazy_load!, to: :all
    end
  end
end

ActiveRecord::Querying.prepend(PireLoader::Patches::Querying)
