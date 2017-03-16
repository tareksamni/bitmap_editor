# frozen_string_literal: true
describe Command do
  let(:command) { Command.new(input) }

  describe '#initialize' do
    context 'invalid input format' do
      let(:input) { 'I A' }
      it 'should raise an invalid format error' do
        expect { command }.to raise_error(Command::InvalidFormatError)
      end
    end

    context 'valid input format' do
      let(:should_not_raise_error) do
        expect { command }.to_not raise_error
      end

      context '`I M N`' do
        let(:input) { 'I 5 5' }
        it 'should not raise an invalid format error' do
          should_not_raise_error
        end
      end

      context '`C`' do
        let(:input) { 'C' }
        it 'should not raise an invalid format error' do
          should_not_raise_error
        end
      end

      context '`L X Y C`' do
        let(:input) { 'L 2 3 C' }
        it 'should not raise an invalid format error' do
          should_not_raise_error
        end
      end

      context '`F X Y C`' do
        let(:input) { 'F 2 3 C' }
        it 'should not raise an invalid format error' do
          should_not_raise_error
        end
      end

      context '`V X Y1 Y2 C`' do
        let(:input) { 'V 1 2 4 C' }
        it 'should not raise an invalid format error' do
          should_not_raise_error
        end
      end

      context '`H X1 X2 Y C`' do
        let(:input) { 'H 1 2 4 C' }
        it 'should not raise an invalid format error' do
          should_not_raise_error
        end
      end

      context '`S`' do
        let(:input) { 'S' }
        it 'should not raise an invalid format error' do
          should_not_raise_error
        end
      end

      context '`?`' do
        let(:input) { '?' }
        it 'should not raise an error' do
          should_not_raise_error
        end
      end

      context '`X`' do
        let(:input) { 'X' }
        it 'should not raise an error' do
          should_not_raise_error
        end
      end
    end

    context 'invalid command' do
      let(:input) { 'A' }
      it 'should raise an invalid command error' do
        expect { command }.to raise_error(Command::InvalidCommandError)
      end
    end

    context 'valid command' do
      let(:should_raise_invalid_params_error) do
        expect { command }.to raise_error(Command::InvalidFormatError)
      end

      context '`I`' do
        context 'with invalid params' do
          context '(missing params)' do
            let(:input) { 'I 2' }
            it 'should raise invalid params error' do
              should_raise_invalid_params_error
            end
          end

          context '(extra params)' do
            let(:input) { 'I 2 3 4' }
            it 'should raise invalid params error' do
              should_raise_invalid_params_error
            end
          end
        end

        context 'with valid params' do
          let(:input) { 'I 5 6' }
          it 'should set type, x, and y values' do
            expect(command.type).to eq('I')
            expect(command.x).to eq(5)
            expect(command.y).to eq(6)
            expect(command.x_range).to be_nil
            expect(command.y_range).to be_nil
            expect(command.colour).to be_nil
          end
        end
      end

      context '`C`' do
        context 'with invalid extra params' do
          let(:input) { 'C 1' }
          it 'should raise invalid params error' do
            should_raise_invalid_params_error
          end
        end

        context 'with valid params' do
          let(:input) { 'C' }
          it 'should set type value' do
            expect(command.type).to eq('C')
            expect(command.x).to be_nil
            expect(command.y).to be_nil
            expect(command.x_range).to be_nil
            expect(command.y_range).to be_nil
            expect(command.colour).to be_nil
          end
        end
      end

      context '`F`' do
        context 'with invalid params' do
          context '(missing params)' do
            let(:input) { 'F 1 2' }
            it 'should raise invalid params error' do
              should_raise_invalid_params_error
            end
          end

          context '(extra params)' do
            let(:input) { 'F 1 2 C 1' }
            it 'should raise invalid params error' do
              should_raise_invalid_params_error
            end
          end
        end

        context 'with valid params' do
          let(:input) { 'F 1 2 C' }
          it 'should set type, x, y and colour values' do
            expect(command.type).to eq('F')
            expect(command.x).to eq(1)
            expect(command.y).to eq(2)
            expect(command.x_range).to be_nil
            expect(command.y_range).to be_nil
            expect(command.colour).to eq('C')
          end
        end
      end

      context '`L`' do
        context 'with invalid params' do
          context '(missing params)' do
            let(:input) { 'L 1 2' }
            it 'should raise invalid params error' do
              should_raise_invalid_params_error
            end
          end

          context '(extra params)' do
            let(:input) { 'L 1 2 C 1' }
            it 'should raise invalid params error' do
              should_raise_invalid_params_error
            end
          end
        end

        context 'with valid params' do
          let(:input) { 'L 1 2 C' }
          it 'should set type, x, y and colour values' do
            expect(command.type).to eq('L')
            expect(command.x).to eq(1)
            expect(command.y).to eq(2)
            expect(command.x_range).to be_nil
            expect(command.y_range).to be_nil
            expect(command.colour).to eq('C')
          end
        end
      end

      context '`V`' do
        context 'with invalid params' do
          context '(missing params)' do
            let(:input) { 'V 1 1 2' }
            it 'should raise invalid params error' do
              should_raise_invalid_params_error
            end
          end

          context '(extra params)' do
            let(:input) { 'V 1 1 2 C 1' }
            it 'should raise invalid params error' do
              should_raise_invalid_params_error
            end
          end
        end

        context 'with valid params' do
          let(:input) { 'V 1 1 2 C' }
          it 'should set type, x, y_range and colour values' do
            expect(command.type).to eq('V')
            expect(command.x).to eq(1)
            expect(command.y).to be_nil
            expect(command.x_range).to be_nil
            expect(command.y_range).to eq(1..2)
            expect(command.colour).to eq('C')
          end
        end
      end

      context '`H`' do
        context 'with invalid params' do
          context '(missing params)' do
            let(:input) { 'H 1 2 2' }
            it 'should raise invalid params error' do
              should_raise_invalid_params_error
            end
          end

          context '(extra params)' do
            let(:input) { 'H 1 2 2 C 1' }
            it 'should raise invalid params error' do
              should_raise_invalid_params_error
            end
          end
        end

        context 'with valid params' do
          let(:input) { 'H 1 2 2 C' }
          it 'should set type, x_range, y and colour values' do
            expect(command.type).to eq('H')
            expect(command.x_range).to eq(1..2)
            expect(command.y).to eq(2)
            expect(command.x).to be_nil
            expect(command.y_range).to be_nil
            expect(command.colour).to eq('C')
          end
        end
      end

      context '`S`' do
        context 'with invalid extra params' do
          let(:input) { 'S 1' }
          it 'should raise invalid params error' do
            should_raise_invalid_params_error
          end
        end

        context 'with valid params' do
          let(:input) { 'S' }
          it 'should set type value' do
            expect(command.type).to eq('S')
            expect(command.x).to be_nil
            expect(command.y).to be_nil
            expect(command.x_range).to be_nil
            expect(command.y_range).to be_nil
            expect(command.colour).to be_nil
          end
        end
      end

      context '`?`' do
        context 'with invalid extra params' do
          let(:input) { '? 1' }
          it 'should raise invalid params error' do
            should_raise_invalid_params_error
          end
        end

        context 'with valid params' do
          let(:input) { '?' }
          it 'should set type value' do
            expect(command.type).to eq('?')
            expect(command.x).to be_nil
            expect(command.y).to be_nil
            expect(command.x_range).to be_nil
            expect(command.y_range).to be_nil
            expect(command.colour).to be_nil
          end
        end
      end

      context '`X`' do
        context 'with invalid extra params' do
          let(:input) { 'X 1' }
          it 'should raise invalid params error' do
            should_raise_invalid_params_error
          end
        end

        context 'with valid params' do
          let(:input) { 'X' }
          it 'should set type value' do
            expect(command.type).to eq('X')
            expect(command.x).to be_nil
            expect(command.y).to be_nil
            expect(command.x_range).to be_nil
            expect(command.y_range).to be_nil
            expect(command.colour).to be_nil
          end
        end
      end
    end

  end
end
