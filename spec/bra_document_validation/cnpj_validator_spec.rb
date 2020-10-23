# frozen_string_literal: true

RSpec.describe BraDocumentValidation::CNPJValidator, type: :validator do
  describe '#validate_each' do
    let(:attribute) { :cnpj }
    let(:record) { double(:active_model, errors: errors) }
    let(:errors) { double(:errros) }

    describe 'format validation' do
      context 'when formated option is not informed' do
        subject(:cnpj_validator) { described_class.new(attributes: [attribute]) }

        context 'but the cnpj is formatted' do
          let(:attr_value) { '32.648.824/0001-59' }

          it 'appoints an invalid CNPJ format' do
            expect(errors).to receive(:add).with(attribute, :invalid_format)
            cnpj_validator.validate_each(record, attribute, attr_value)
          end
        end

        context 'but the cnpj has an invalid raw format' do
          let(:attr_value) { '32648824000169a' }

          it 'appoints an invalid CNPJ format' do
            expect(errors).to receive(:add).with(attribute, :invalid_format)
            cnpj_validator.validate_each(record, attribute, attr_value)
          end
        end

        context 'and the cnpj has a valid raw format' do
          let(:attr_value) { '32648824000169' }

          it 'accepts the number' do
            expect(errors).to_not receive(:add)
            cnpj_validator.validate_each(record, attribute, attr_value)
          end
        end
      end

      context 'when formatted option is informed' do
        subject(:cnpj_validator) { described_class.new(attributes: [attribute], formatted: formatted) }

        context 'and formatted option is false' do
          let(:formatted) { false }

          context 'but the cnpj is formatted' do
            let(:attr_value) { '32.648.824/0001-59' }

            it 'appoints an invalid CNPJ format' do
              expect(errors).to receive(:add).with(attribute, :invalid_format)
              cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end

          context 'but the cnpj has an invalid raw format' do
            let(:attr_value) { '32648824000169a' }

            it 'appoints an invalid CNPJ format' do
              expect(errors).to receive(:add).with(attribute, :invalid_format)
              cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end

          context 'and the cnpj has a valid raw format' do
            let(:attr_value) { '32648824000169' }

            it 'accepts the number' do
              expect(errors).to_not receive(:add)
              cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end
        end

        context 'and formatted option is true' do
          let(:formatted) { true }

          context 'but the cnpj has a valid raw format' do
            let(:attr_value) { '32648824000169' }

            it 'appoints an invalid CNPJ format' do
              expect(errors).to receive(:add).with(attribute, :invalid_format)
              cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end

          context 'but the cnpj has an invalid formatted format' do
            let(:attr_value) { '32648824000169a' }

            it 'appoints an invalid CNPJ format' do
              expect(errors).to receive(:add).with(attribute, :invalid_format)
              cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end

          context 'and the cnpj is formatted' do
            let(:attr_value) { '07.016.824/2725-22' }

            it 'accepts the number' do
              expect(errors).to_not receive(:add)
              cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end
        end
      end
    end

    describe 'verifying digit validation' do
      subject(:cnpj_validator) { described_class.new(attributes: [attribute], formatted: true) }

      context 'when all digits are the same one' do
        let(:attr_value) { BraDocuments::Formatter.format(Array.new(14, rand(10)).join, as: :cnpj) }

        it 'appoints an invalid verification digit' do
          expect(errors).to receive(:add).with(attribute, :invalid_verification_digit)
          cnpj_validator.validate_each(record, attribute, attr_value)
        end
      end

      context 'when the first verification number is not valid' do
        let(:attr_value) { '32.648.824/0001-59' }

        it 'appoints an invalid verification digit' do
          expect(errors).to receive(:add).with(attribute, :invalid_verification_digit)
          cnpj_validator.validate_each(record, attribute, attr_value)
        end
      end

      context 'when the second verification number is not valid' do
        let(:attr_value) { '32.648.824/0001-64' }

        it 'appoints an invalid verification digit' do
          expect(errors).to receive(:add).with(attribute, :invalid_verification_digit)
          cnpj_validator.validate_each(record, attribute, attr_value)
        end
      end

      context 'when it is a verified number' do
        let(:attr_value) { '32.648.824/0001-69' }

        it 'accepts the number' do
          expect(errors).to_not receive(:add)
          cnpj_validator.validate_each(record, attribute, attr_value)
        end
      end
    end
  end
end
