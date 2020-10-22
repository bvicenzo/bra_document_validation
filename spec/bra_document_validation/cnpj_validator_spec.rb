# frozen_string_literal: true

RSpec.describe BraDocumentValidation::CNPJValidator, type: :validator do
  describe '#validate_each' do
    subject(:cnpj_validator) { described_class.new(attributes: [attribute]) }

    let(:attribute) { :cnpj }
    let(:record) { double(:active_model, errors: errors) }
    let(:errors) { double(:errros) }

    context 'when the attribute value is not a CNPJ format' do
      let(:attr_value) { '32648824000169' }

      it 'appoints an invalid CNPJ format' do
        expect(errors).to receive(:add).with(attribute, :invalid_format)
        cnpj_validator.validate_each(record, attribute, attr_value)
      end
    end

    context 'when the attribute value is a valid CNPJ format' do
      context 'but all digits are the same one' do
        let(:attr_value) { BraDocuments::Formatter.format(Array.new(14, rand(10)).join, as: :cnpj) }

        it 'appoints an invalid verification digit' do
          expect(errors).to receive(:add).with(attribute, :invalid_verification_digit)
          cnpj_validator.validate_each(record, attribute, attr_value)
        end
      end

      context 'but the first verification number is not valid' do
        let(:attr_value) { '32.648.824/0001-59' }

        it 'appoints an invalid verification digit' do
          expect(errors).to receive(:add).with(attribute, :invalid_verification_digit)
          cnpj_validator.validate_each(record, attribute, attr_value)
        end
      end

      context 'but the second verification number is not valid' do
        let(:attr_value) { '32.648.824/0001-64' }

        it 'appoints an invalid verification digit' do
          expect(errors).to receive(:add).with(attribute, :invalid_verification_digit)
          cnpj_validator.validate_each(record, attribute, attr_value)
        end
      end

      context 'and it is a verified number' do
        let(:attr_value) { '32.648.824/0001-69' }

        it 'accepts the number' do
          expect(errors).to_not receive(:add)
          cnpj_validator.validate_each(record, attribute, attr_value)
        end
      end
    end
  end
end
