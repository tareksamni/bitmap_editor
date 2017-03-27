# frozen_string_literal: true
require 'matrix'
class Bitmap < Matrix
  InvalidRangeError = Class.new(StandardError)
  OutOfImageCoordinatesError = Class.new(StandardError)
  PixelNotFoundError = Class.new(StandardError)
  PIXEL_NOT_FOUND_MSG = 'Pixel not found'

  NEIGHBOURS_OFFSIT = [
    [-1, 0], # Up
    [0, 1],  # Right
    [1, 0],  # Down
    [0, -1]  # Left
  ].freeze

  def [](y, x)
    @rows.fetch(y - 1) { return nil }[x - 1]
  end

  def set_colour(y, x, colour)
    validate_coordinates!(y, x)
    pixel = self[y, x]
    raise PixelNotFoundError, PIXEL_NOT_FOUND_MSG if pixel.nil?
    pixel.colour = colour
  end

  def set_vertical_colour_range(x, y_range, colour)
    validate_range!(y_range, row_size)
    y_range.each do |y|
      set_colour(y, x, colour)
    end
  end

  def set_horizontal_colour_range(x_range, y, colour)
    validate_range!(x_range, column_size)
    x_range.each do |x|
      set_colour(y, x, colour)
    end
  end

  def fill(y, x, colour)
    validate_coordinates!(y, x)
    pixel = self[y, x]
    raise PixelNotFoundError, PIXEL_NOT_FOUND_MSG if pixel.nil?
    target_pixel = pixel.dup
    return if colour == pixel.colour
    pixel.colour = colour
    neighbours(y, x).each do |neighbour_y, neighbour_x|
      fill(neighbour_y, neighbour_x, colour) if should_fill?(neighbour_y, neighbour_x, target_pixel)
    end
  end

  def to_s
    to_a.map { |cols| cols.map(&:to_s).join('') }.join("\n")
  end

  private

  def should_fill?(y, x, target_pixel)
    valid_coordinates?(y, x) && self[y, x].same_colour?(target_pixel)
  end

  def validate_range!(range, max)
    error_message = "Provided range should be between 1 and #{max} in ascending order"
    raise InvalidRangeError, error_message unless valid_range?(range, max)
  end

  def neighbours(y, x)
    NEIGHBOURS_OFFSIT.map do |y_offsit, x_offsit|
      [y + y_offsit, x + x_offsit]
    end
  end

  def valid_range?(range, max)
    not_nil = !range.first.nil? && !range.last.nil?
    sorted_range = range.first < range.last
    is_range = range.is_a?(Range)
    within_correct_range = range.first.positive? && range.last <= max
    not_nil && sorted_range && is_range && within_correct_range
  end

  def validate_coordinates!(y, x)
    out_of_image__coordinates = "X(#{x}), Y(#{y}) should be between 1,1 and #{column_size}, #{row_size}"
    raise OutOfImageCoordinatesError, out_of_image__coordinates unless valid_coordinates?(y, x)
  end

  def valid_coordinates?(y, x)
    y.positive? && x.positive? && y.is_a?(Integer) && x.is_a?(Integer) && within_accepted_range?(y, x)
  end

  def within_accepted_range?(y, x)
    y <= row_size && x <= column_size
  end
end
