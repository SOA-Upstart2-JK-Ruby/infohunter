# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'category'

module HobbyCatcher
  module Entity
    # Domain entity for Hobby
    # Aggregate root for hobbies
    class Hobby < Dry::Struct
      include Dry.Types

      attribute :id,          Integer.optional
      attribute :hobby_id,    Strict::Integer 
      attribute :hobby_name,  Strict::String
      attribute :description, Strict::String
      attribute :hobby_img,   Strict::String
      attribute :count,       Strict::Integer
      attribute :categories,  Strict::Array.of(Category)

      def to_attr_hash
        to_hash.reject { |key, _| %i[id categories].include? key }
      end
    end
  end
end