# frozen_string_literal: true
describe Bitmap do
  describe '#build' do
    it 'should build a bitmap with (x,y)' do
      bitmap = Bitmap.build(1, 1) { Pixel.new }
      expect(bitmap.row_size).to eq(1)
      expect(bitmap.column_size).to eq(1)
      expect(bitmap[1, 1]).to be_a(Pixel)
    end
  end

  context 'with a bitmap' do
    let(:bitmap) { Bitmap.build(4, 5) { Pixel.new } }

    describe '#to_s' do
      it 'should return the bitmap string representation' do
        expect(bitmap.to_s).to eq("OOOOO\nOOOOO\nOOOOO\nOOOOO")
      end
    end

    describe '#set_colour' do
      context 'using a valid (x,y)=(2,3)' do
        it "should set pixel's colour" do
          bitmap.set_colour(2, 3, 'X')
          expect(bitmap[2, 3].to_s).to eq('X')
          expect(bitmap[3, 4].to_s).not_to eq('X')
        end
      end

      context 'using a invalid (x,y)=(5,5)' do
        it 'should raise error' do
          expect { bitmap.set_colour(5, 5, 'X') }.to raise_error(Bitmap::OutOfImageCoordinatesError)
        end
      end
    end

    describe '#fill' do
      context 'using a valid (x,y)=(2,3)' do
        it 'should set pixels region colour' do
          bitmap.set_colour(1, 1, 'X')
          bitmap.set_colour(2, 1, 'X')
          bitmap.set_colour(1, 2, 'R')
          bitmap.set_colour(2, 2, 'R')
          bitmap.set_colour(3, 2, 'X')
          bitmap.fill(1, 1, 'A')
          expect(bitmap[1, 1].to_s).to eq('A')
          expect(bitmap[2, 1].to_s).to eq('A')
          expect(bitmap[1, 2].to_s).to eq('R')
          expect(bitmap[2, 2].to_s).to eq('R')
          expect(bitmap[3, 2].to_s).to eq('X')
        end
      end

      context 'using a valid (x,y)=(2,3) with same color as original' do
        it 'should set pixels region colour' do
          bitmap.set_colour(1, 1, 'X')
          bitmap.set_colour(2, 1, 'X')
          bitmap.set_colour(1, 2, 'R')
          bitmap.set_colour(2, 2, 'R')
          bitmap.set_colour(3, 2, 'X')
          bitmap.fill(1, 1, 'X')
          expect(bitmap[1, 1].to_s).to eq('X')
          expect(bitmap[2, 1].to_s).to eq('X')
          expect(bitmap[1, 2].to_s).to eq('R')
          expect(bitmap[2, 2].to_s).to eq('R')
          expect(bitmap[3, 2].to_s).to eq('X')
        end
      end

      context 'using a invalid (x,y)=(5,5)' do
        it 'should raise error' do
          expect { bitmap.fill(5, 5, 'X') }.to raise_error(Bitmap::OutOfImageCoordinatesError)
        end
      end
    end

    describe '#set_vertical_colour_range' do
      context 'with valid range' do
        it 'should set color in y range' do
          bitmap.set_vertical_colour_range(1, 1..2, 'X')
          expect(bitmap[1, 1].to_s).to eq('X')
          expect(bitmap[2, 1].to_s).to eq('X')
          expect(bitmap[3, 1].to_s).to eq('O')
        end
      end

      context 'with invalid range' do
        it 'should raise error' do
          expect { bitmap.set_vertical_colour_range(5, 4..6, 'X') }.to raise_error(Bitmap::InvalidRangeError)
          expect { bitmap.set_vertical_colour_range(5, 3..-6, 'X') }.to raise_error(Bitmap::InvalidRangeError)
        end
      end
    end

    describe '#set_horizontal_colour_range' do
      context 'with valid range' do
        it 'should set color in x range' do
          bitmap.set_horizontal_colour_range(1..3, 3, 'C')
          expect(bitmap[3, 1].to_s).to eq('C')
          expect(bitmap[3, 2].to_s).to eq('C')
          expect(bitmap[3, 3].to_s).to eq('C')
          expect(bitmap[3, 4].to_s).to eq('O')
        end
      end

      context 'with invalid range' do
        it 'should raise error' do
          expect { bitmap.set_horizontal_colour_range(5..7, 6, 'X') }.to raise_error(Bitmap::InvalidRangeError)
          expect { bitmap.set_horizontal_colour_range(4..-7, 3, 'X') }.to raise_error(Bitmap::InvalidRangeError)
        end
      end
    end
  end
end
