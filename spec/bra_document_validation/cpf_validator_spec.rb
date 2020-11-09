# frozen_string_literal: true

RSpec.describe BraDocumentValidation::CPFValidator, type: :validator do
  describe '#validate_each' do
    let(:attribute) { :cpf }
    let(:record) { double(:active_model, errors: errors) }
    let(:errors) { double(:errros) }

    describe 'format validation' do
      context 'when formated option is not informed' do
        subject(:cpf_validator) { described_class.new(attributes: [attribute]) }

        context 'but the cpf is formatted' do
          let(:attr_value) { '123.456.700-88' }

          it 'appoints an invalid cpf format' do
            expect(errors).to receive(:add).with(attribute, :invalid_format)
            cpf_validator.validate_each(record, attribute, attr_value)
          end
        end

        context 'but the cpf has an invalid raw format' do
          let(:attr_value) { '12345670088a' }

          it 'appoints an invalid cpf format' do
            expect(errors).to receive(:add).with(attribute, :invalid_format)
            cpf_validator.validate_each(record, attribute, attr_value)
          end
        end

        context 'and the cpf has a valid raw format' do
          let(:attr_value) { '12345670088' }

          it 'accepts the number' do
            expect(errors).to_not receive(:add)
            cpf_validator.validate_each(record, attribute, attr_value)
          end
        end
      end

      context 'when formatted option is informed' do
        subject(:cpf_validator) { described_class.new(attributes: [attribute], formatted: formatted) }

        context 'and formatted option is false' do
          let(:formatted) { false }

          context 'but the cpf is formatted' do
            let(:attr_value) { '123.456.700-88' }

            it 'appoints an invalid cpf format' do
              expect(errors).to receive(:add).with(attribute, :invalid_format)
              cpf_validator.validate_each(record, attribute, attr_value)
            end
          end

          context 'but the cpf has an invalid raw format' do
            let(:attr_value) { '123456700889' }

            it 'appoints an invalid cpf format' do
              expect(errors).to receive(:add).with(attribute, :invalid_format)
              cpf_validator.validate_each(record, attribute, attr_value)
            end
          end

          context 'and the cpf has a valid raw format' do
            let(:attr_value) { '12345670088' }

            it 'accepts the number' do
              expect(errors).to_not receive(:add)
              cpf_validator.validate_each(record, attribute, attr_value)
            end
          end
        end

        context 'and formatted option is true' do
          let(:formatted) { true }

          context 'but the cpf has a valid raw format' do
            let(:attr_value) { '12345670088' }

            it 'appoints an invalid cpf format' do
              expect(errors).to receive(:add).with(attribute, :invalid_format)
              cpf_validator.validate_each(record, attribute, attr_value)
            end
          end

          context 'but the cpf has an invalid formatted format' do
            let(:attr_value) { '123.4567.008-8' }

            it 'appoints an invalid cpf format' do
              expect(errors).to receive(:add).with(attribute, :invalid_format)
              cpf_validator.validate_each(record, attribute, attr_value)
            end
          end

          context 'and the cpf is formatted' do
            let(:attr_value) { '123.456.700-88' }

            it 'accepts the number' do
              expect(errors).to_not receive(:add)
              cpf_validator.validate_each(record, attribute, attr_value)
            end
          end
        end
      end
    end

    describe 'verifying digit validation' do
      subject(:cpf_validator) { described_class.new(attributes: [attribute], formatted: true) }

      context 'when all digits are the same one' do
        let(:attr_value) { BraDocuments::Formatter.format(Array.new(11, rand(10)).join, as: :cpf) }

        it 'appoints an invalid verification digit' do
          expect(errors).to receive(:add).with(attribute, :invalid_verification_digit)
          cpf_validator.validate_each(record, attribute, attr_value)
        end
      end

      context 'when the first verification number is not valid' do
        let(:attr_value) { '123.456.700-98' }

        it 'appoints an invalid verification digit' do
          expect(errors).to receive(:add).with(attribute, :invalid_verification_digit)
          cpf_validator.validate_each(record, attribute, attr_value)
        end
      end

      context 'when the second verification number is not valid' do
        let(:attr_value) { '123.456.700-89' }

        it 'appoints an invalid verification digit' do
          expect(errors).to receive(:add).with(attribute, :invalid_verification_digit)
          cpf_validator.validate_each(record, attribute, attr_value)
        end
      end

      context 'when it is a verified number' do
        let(:attr_value) { '123.456.700-88' }

        it 'accepts the number' do
          expect(errors).to_not receive(:add)
          cpf_validator.validate_each(record, attribute, attr_value)
        end
      end
    end
  end
end
