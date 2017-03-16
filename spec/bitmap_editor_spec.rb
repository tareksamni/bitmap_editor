# frozen_string_literal: true

describe BitmapEditor do
  let(:bitmap_editor) { BitmapEditor.new }
  let(:single_run) { bitmap_editor.send(:single_run, input) }

  describe '#run' do
    context 'with invalid command' do
      let(:input) { '1 1 L C' }
      it 'should raise an error' do
        expect { single_run }.to raise_error(Command::InvalidFormatError)
      end
    end

    context 'with valid command' do
      context 'with `I` command' do
        context 'with valid params' do
          let(:input) { 'I 5 5' }
          it 'should set bitmap with correct x,y' do
            expect(Bitmap).to receive(:build).with(5, 5)
            single_run
          end
        end

        context 'with invalid params' do
          let(:input) { 'I 5 251' }
          it 'should raise error' do
            expect { single_run }.to raise_error(Command::InvalidFormatError)
          end

          let(:input) { 'I 5 -1' }
          it 'should raise error' do
            expect { single_run }.to raise_error(Command::InvalidFormatError)
          end
        end
      end

      context 'with `C` command' do
        context 'with no params' do
          let(:input) { 'C' }
          context 'with bitmap initialized' do
            it 'should create a new bitmap with old dimensions' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect(Bitmap).to receive(:build).with(5, 5)
              single_run
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(BitmapEditor::BadBitmapError)
            end
          end
        end

        context 'with wrong params' do
          let(:input) { 'C 1' }
          context 'with bitmap initialized' do
            it 'should raise an error' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end
        end
      end

      context 'with `L` command' do
        context 'with correct params' do
          let(:input) { 'L 1 2 C' }
          context 'with bitmap initialized' do
            it 'should color the selected pixel with given color' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect(bitmap_editor.bitmap).to receive(:set_colour).with(2, 1, 'C')
              single_run
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(BitmapEditor::BadBitmapError)
            end
          end
        end

        context 'with wrong params' do
          let(:input) { 'L 1' }
          context 'with bitmap initialized' do
            it 'should raise an error' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end
        end
      end

      context 'with `F` command' do
        context 'with correct params' do
          let(:input) { 'F 1 2 C' }
          context 'with bitmap initialized' do
            it "should color the selected pixel's region with given color" do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect(bitmap_editor.bitmap).to receive(:fill).with(2, 1, 'C')
              single_run
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(BitmapEditor::BadBitmapError)
            end
          end
        end

        context 'with wrong params' do
          let(:input) { 'F 1' }
          context 'with bitmap initialized' do
            it 'should raise an error' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end
        end
      end

      context 'with `V` command' do
        context 'with correct params' do
          let(:input) { 'V 1 1 3 A' }
          context 'with bitmap initialized' do
            it 'should color the selected pixel range with given color' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect(bitmap_editor.bitmap).to receive(:set_vertical_colour_range).with(1, 1..3, 'A')
              single_run
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(BitmapEditor::BadBitmapError)
            end
          end
        end

        context 'with wrong params' do
          let(:input) { 'V 1' }
          context 'with bitmap initialized' do
            it 'should raise an error' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end
        end
      end

      context 'with `H` command' do
        context 'with correct params' do
          let(:input) { 'H 1 3 1 A' }
          context 'with bitmap initialized' do
            it 'should color the selected pixel range with given color' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect(bitmap_editor.bitmap).to receive(:set_horizontal_colour_range).with(1..3, 1, 'A')
              single_run
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(BitmapEditor::BadBitmapError)
            end
          end
        end

        context 'with wrong params' do
          let(:input) { 'H 1' }
          context 'with bitmap initialized' do
            it 'should raise an error' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end
        end
      end

      context 'with `S` command' do
        context 'with no params' do
          let(:input) { 'S' }
          context 'with bitmap initialized' do
            it 'should print the bitmap' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect(bitmap_editor.bitmap).to receive(:to_s)
              expect(bitmap_editor).to receive(:puts)
              single_run
            end
          end

          context 'without bitmap initialized' do
            it 'should print the bitmap' do
              expect(bitmap_editor.bitmap).to receive(:to_s)
              expect(bitmap_editor).to receive(:puts)
              single_run
            end
          end
        end

        context 'with wrong params' do
          let(:input) { 'S 1' }
          context 'with bitmap initialized' do
            it 'should raise an error' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end
        end
      end

      context 'with `X` command' do
        context 'with no params' do
          let(:input) { 'X' }
          context 'with bitmap initialized' do
            it 'should set running false and print goodbye message' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect(bitmap_editor).to receive(:puts).with(BitmapEditor::TERMINATE_OUTPUT)
              single_run
              expect(bitmap_editor.instance_variable_get('@running')).to eq(false)
            end
          end

          context 'without bitmap initialized' do
            it 'should set running false and print goodbye message' do
              expect(bitmap_editor).to receive(:puts).with(BitmapEditor::TERMINATE_OUTPUT)
              single_run
              expect(bitmap_editor.instance_variable_get('@running')).to eq(false)
            end
          end
        end

        context 'with wrong params' do
          let(:input) { 'X 1' }
          context 'with bitmap initialized' do
            it 'should raise an error' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end
        end
      end
      context 'with `?` command' do
        context 'with no params' do
          let(:input) { '?' }
          context 'with bitmap initialized' do
            it 'should print the help message' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect(bitmap_editor).to receive(:puts).with(BitmapEditor::HELP_OUTPUT)
              single_run
            end
          end

          context 'without bitmap initialized' do
            it 'should print the help message' do
              expect(bitmap_editor).to receive(:puts).with(BitmapEditor::HELP_OUTPUT)
              single_run
            end
          end
        end

        context 'with wrong params' do
          let(:input) { '? 1' }
          context 'with bitmap initialized' do
            it 'should raise an error' do
              bitmap_editor.bitmap = Bitmap.build(5, 5) { Pixel.new }
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end

          context 'without bitmap initialized' do
            it 'should raise an error' do
              expect { single_run }.to raise_error(Command::InvalidFormatError)
            end
          end
        end
      end
    end
  end
end
