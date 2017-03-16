# frozen_string_literal: true
class Command

  InvalidFormatError = Class.new(StandardError)
  InvalidCommandError = Class.new(StandardError)

  VALID_TYPES = %w(I C L V H S ? X F).freeze
  VALID_FORMAT_REGEX = /^([A-Z|\?])\s*(\d*)\s*(\d*)\s*(\d*)\s*([A-Z]*)$/
  INVALID_ERROR_MSG = 'Invalid format for the command, ? for help'
  INVALID_COMMAND_MSG = "Invalid command, possible commands are: #{VALID_TYPES.join(', ')}"

  attr_accessor :type, :x, :y, :x_range, :y_range, :colour

  def initialize(input)
    parsed = parse_and_validate_format!(input)
    @type = parsed.shift
    validate_type!
    validate_and_assign_params!(parsed)
  end

  private

  def validate_and_assign_params!(params)
    case @type
    when 'I'
      new_image_params!(params)
    when 'L'
      colouring_params!(params)
    when 'V'
      range_colouring_params!(params)
    when 'H'
      range_colouring_params!(params)
    when 'F'
      colouring_params!(params)
    else
      validate_no_params!(params)
    end
  end

  def raise_invalid_format!
    raise InvalidFormatError, INVALID_ERROR_MSG
  end

  def validate_type!
    raise InvalidCommandError, INVALID_COMMAND_MSG unless VALID_TYPES.include?(@type)
  end

  def new_image_params!(params)
    invalid_format = params[0].empty? || params[1].empty? || !params[2].empty? || !params[3].empty?
    raise_invalid_format! if invalid_format
    @x, @y = params[0..1].map(&:to_i)
  end

  def colouring_params!(params)
    invalid_format = params[0].empty? || params[1].empty? || !params[2].empty? || params[3].empty?
    raise_invalid_format! if invalid_format
    @x, @y = params[0..1].map(&:to_i)
    @colour = params[3]
  end

  def range_colouring_params!(params)
    invalid_format = params.any?(&:empty?) || params.size != 4
    raise_invalid_format! if invalid_format
    if @type == 'V'
      @x = params[0].to_i
      y1 = params[1].to_i
      y2 = params[2].to_i
      @y_range = y1..y2
    else
      x1 = params[0].to_i
      x2 = params[1].to_i
      @x_range = x1..x2
      @y = params[2].to_i
    end
    @colour = params[3]
  end

  def parse_and_validate_format!(input)
    parsed = input.scan(VALID_FORMAT_REGEX)
    raise_invalid_format! if parsed.empty?
    parsed[0]
  end

  def validate_no_params!(params)
    raise_invalid_format! unless params.all?(&:empty?)
  end
end
