# frozen_string_literal: true
describe Pixel do
  let(:pixel) { Pixel.new }
  let(:coloured_pixel) { Pixel.from_colour('A') }
  let(:another_coloured_pixel) { Pixel.from_colour('A') }

  describe '#initialize' do
    it 'should initialize with default colour `O`' do
      expect(pixel.colour).to eq('O')
    end
  end

  describe '#from_colour' do
    it 'should initialize pixel and set colour as given' do
      expect(coloured_pixel.colour).to eq('A')
    end
  end

  describe '#same_colour?' do
    it 'should return true if same colour or false otherwise' do
      expect(coloured_pixel.same_colour?(pixel)).to be false
      expect(coloured_pixel.same_colour?(another_coloured_pixel)).to be true
    end
  end

  describe '#colour=' do
    context 'using single capital letter from [A-Z]' do
      it 'should set colour successfully' do
        pixel.colour = 'A'
        expect(pixel.colour).to eq('A')
      end
    end

    context 'using multiple capital letters from [A-Z]' do
      it 'should raise an invalid colour error' do
        expect { pixel.colour = 'AA' }.to raise_error(Pixel::InvalidColourError)
      end
    end

    context 'using single small letters from [a-z]' do
      it 'should raise an invalid colour error' do
        expect { pixel.colour = 'a' }.to raise_error(Pixel::InvalidColourError)
      end
    end

    context 'using multiple small letters from [a-z]' do
      it 'should raise an invalid colour error' do
        expect { pixel.colour = 'aa' }.to raise_error(Pixel::InvalidColourError)
      end
    end

    context 'using multiple letters from [A-Za-z]' do
      it 'should raise an invalid colour error' do
        expect { pixel.colour = 'Aa' }.to raise_error(Pixel::InvalidColourError)
      end
    end

    context 'using multiple letters from [A-Za-z0-9]' do
      it 'should raise an invalid colour error' do
        expect { pixel.colour = 'Aa0' }.to raise_error(Pixel::InvalidColourError)
        expect { pixel.colour = 'A0' }.to raise_error(Pixel::InvalidColourError)
        expect { pixel.colour = 'a0' }.to raise_error(Pixel::InvalidColourError)
      end
    end

    context 'using single number' do
      it 'should raise an invalid colour error' do
        expect { pixel.colour = '1' }.to raise_error(Pixel::InvalidColourError)
      end
    end

    context 'using multiple numbers' do
      it 'should raise an invalid colour error' do
        expect { pixel.colour = '12' }.to raise_error(Pixel::InvalidColourError)
      end
    end

    context 'using special chars' do
      it 'should raise an invalid colour error' do
        expect { pixel.colour = '!' }.to raise_error(Pixel::InvalidColourError)
        expect { pixel.colour = '`' }.to raise_error(Pixel::InvalidColourError)
      end
    end
  end
end
