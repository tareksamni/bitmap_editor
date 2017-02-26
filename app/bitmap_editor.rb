# frozen_string_literal: true
class BitmapEditor
  BadBitmapError = Class.new(StandardError)
  WELCOME_MSG = 'type ? for help'
  BITMAP_NEEDED_MSG = 'Bitmap must be created first. Use the `?` command for help.'
  BAD_BITMAP_DIMENSION_MSG = 'Bitmap dimension must be between (1,1) and (250,250)'
  TERMINATE_OUTPUT = 'goodbye!'
  HELP_OUTPUT = "? - Help
I M N - Create a new M x N image with all pixels coloured white (O).
C - Clears the table, setting all pixels to white (O).
L X Y C - Colours the pixel (X,Y) with colour C.
V X Y1 Y2 C - Draw a vertical segment of colour C in column X \
between rows Y1 and Y2 (inclusive).
H X1 X2 Y C - Draw a horizontal segment of colour C in row Y \
between columns X1 and X2 (inclusive).
S - Show the contents of the current image
X - Terminate the session"

  attr_accessor :bitmap

  def run
    @running = true
    puts WELCOME_MSG
    while @running
      print '> '
      input = gets.chomp
      begin
        single_run(input)
      rescue StandardError => e
        puts e.message
      end
    end
  end

  private

  def single_run(input)
    command = Command.new(input)
    case command.type
    when 'I'
      @bitmap = new_bitmap(command.x, command.y)
    when 'C'
      validate_bitmap!
      @bitmap = new_bitmap
    when 'L'
      validate_bitmap!
      @bitmap.set_colour(command.x, command.y, command.colour)
    when 'V'
      validate_bitmap!
      @bitmap.set_vertical_colour_range(command.x, command.y_range, command.colour)
    when 'H'
      validate_bitmap!
      @bitmap.set_horizontal_colour_range(command.x_range, command.y, command.colour)
    when 'S'
      puts @bitmap.to_s
    when '?'
      puts HELP_OUTPUT
    when 'X'
      exit_console
    end
  end

  def new_bitmap(x = nil, y = nil)
    if x.nil? || y.nil?
      validate_bitmap!
      x = @bitmap.row_size
      y = @bitmap.column_size
    end
    raise BadBitmapError, BAD_BITMAP_DIMENSION_MSG if x > 250 || y > 250 || !x.positive? || !y.positive?
    Bitmap.build(x, y) { Pixel.new }
  end

  def validate_bitmap!
    raise BadBitmapError, BITMAP_NEEDED_MSG if @bitmap.nil?
  end

  def exit_console
    puts TERMINATE_OUTPUT
    @running = false
  end
end
