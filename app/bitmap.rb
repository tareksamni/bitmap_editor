# frozen_string_literal: true
require 'matrix'
class Bitmap < Matrix
  InvalidRangeError = Class.new(StandardError)
  OutOfImageCoordinatesError = Class.new(StandardError)
  PixelNotFoundError = Class.new(StandardError)
  PIXEL_NOT_FOUND_MSG = 'Pixel not found'

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

  def to_s
    to_a.map { |cols| cols.map(&:to_s).join('') }.join("\n")
  end

  private

  def validate_range!(range, max)
    error_message = "Provided range should be between 1 and #{max} in ascending order"
    raise InvalidRangeError, error_message unless valid_range?(range, max)
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
