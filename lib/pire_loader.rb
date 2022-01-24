# frozen_string_literal: true

require "active_record"

require_relative "pire_loader/version"
require_relative "pire_loader/loaders/singular"
require_relative "pire_loader/patches/association"
require_relative "pire_loader/patches/querying"
require_relative "pire_loader/patches/relation"
require_relative "pire_loader/patches/associations/singular_association"
require_relative "pire_loader/patches/base"

module PireLoader
end
