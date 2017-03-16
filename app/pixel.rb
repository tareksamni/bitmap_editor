# frozen_string_literal: true
class Pixel
  DEFAULT_COLOUR = 'O'
  InvalidColourError = Class.new(StandardError)

  attr_reader :colour

  def self.from_colour(colour)
    new.tap do |p|
      p.colour = colour
    end
  end

  def initialize
    @colour = DEFAULT_COLOUR
  end

  def colour=(colour)
    invalid_colour_str = 'Colour value must be a singal Capital letter [A-Z]'
    raise InvalidColourError, invalid_colour_str unless colour =~ /^[A-Z]$/
    @colour = colour
  end

  def to_s
    @colour
  end
end
