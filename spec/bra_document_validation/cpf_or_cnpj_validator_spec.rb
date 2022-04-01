# frozen_string_literal: true

RSpec.describe BraDocumentValidation::CPFOrCNPJValidator, type: :validator do
  describe '#validate_each' do
    let(:attribute) { :document }
    let(:record) { double(:active_model, errors: errors) }
    let(:errors) { double(:errros) }

    describe 'format validation' do
      subject(:cpf_or_cnpj_validator) { described_class.new(attributes: [attribute], formatted: formatted) }

      let(:attr_value) { '123456' }

      before do
        allow(BraDocuments::Matcher)
          .to receive(:match?)
          .with(attr_value, kind: :cpf, mode: mode)
          .and_return(cpf_matched)
      end

      context 'when formatted is true' do
        let(:formatted) { true }
        let(:mode) { :formatted }

        context 'but document does not match with cpf' do
          let(:cpf_matched) { false }

          before do
            allow(BraDocuments::Matcher)
              .to receive(:match?)
              .with(attr_value, kind: :cnpj, mode: mode)
              .and_return(cnpj_matched)
          end

          context 'and document does not match with cnpj also' do
            let(:cnpj_matched) { false }

            it 'appoints an invalid verification digit' do
              expect(errors).to receive(:add).with(attribute, :invalid_format)
              cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end

          context 'and documents matches with cnpj' do
            let(:cnpj_matched) { true }

            before do
              allow(BraDocuments::CPFGenerator).to receive(:valid_verification_digit?)
              allow(BraDocuments::CNPJGenerator).to receive(:valid_verification_digit?)
            end

            it 'accepts that document format' do
              expect(errors).not_to receive(:add).with(attribute, :invalid_format)
              cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end
        end

        context 'and document matches with cpf' do
          let(:cpf_matched) { true }

          before do
            allow(BraDocuments::CPFGenerator).to receive(:valid_verification_digit?)
            allow(BraDocuments::CNPJGenerator).to receive(:valid_verification_digit?)
          end

          it 'accepts that document format' do
            expect(errors).not_to receive(:add).with(attribute, :invalid_format)
            cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
          end
        end
      end

      context 'when formatted is false' do
        let(:formatted) { false }
        let(:mode) { :raw }

        context 'but document does not matches with cpf' do
          let(:cpf_matched) { false }

          before do
            allow(BraDocuments::Matcher)
              .to receive(:match?)
              .with(attr_value, kind: :cnpj, mode: mode)
              .and_return(cnpj_matched)
          end

          context 'and document does not match with cnpj also' do
            let(:cnpj_matched) { false }

            it 'appoints an invalid document format' do
              expect(errors).to receive(:add).with(attribute, :invalid_format)
              cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end

          context 'and documents matches with cnpj' do
            let(:cnpj_matched) { true }

            before do
              allow(BraDocuments::CPFGenerator).to receive(:valid_verification_digit?)
              allow(BraDocuments::CNPJGenerator).to receive(:valid_verification_digit?)
            end

            it 'accepts that document format' do
              expect(errors).not_to receive(:add).with(attribute, :invalid_format)
              cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end
        end

        context 'but document does not matches with cpf' do
          let(:cpf_matched) { true }

          before do
            allow(BraDocuments::CPFGenerator).to receive(:valid_verification_digit?)
            allow(BraDocuments::CNPJGenerator).to receive(:valid_verification_digit?)
          end

          it 'accepts that document format' do
            expect(errors).not_to receive(:add).with(attribute, :invalid_format)
            cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
          end
        end
      end
    end

    describe 'verifying digit validation' do
      subject(:cpf_or_cnpj_validator) { described_class.new(attributes: [attribute], formatted: false) }

      let(:attr_value) { '123456' }

      before do
        allow(BraDocuments::Matcher).to receive(:match?).and_return(true)
        allow(BraDocuments::CPFGenerator)
          .to receive(:valid_verification_digit?)
          .with(document: attr_value)
          .and_return(valid_cpf_digits)
      end

      context 'when cpf does not have valid verifying digit' do
        let(:valid_cpf_digits) { false }

        before do
          allow(BraDocuments::CNPJGenerator)
            .to receive(:valid_verification_digit?)
            .with(document: attr_value)
            .and_return(valid_cnpj_digits)
        end

        context 'and cnpj does not have valid verifying digit also' do
          let(:valid_cnpj_digits) { false }

          it 'appoints an invalid verification digit' do
            expect(errors).to receive(:add).with(attribute, :invalid_verification_digit)
            cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
          end
        end

        context 'and cnpk have valid verification digit' do
          let(:valid_cnpj_digits) { true }

          it 'accepts that document verification digit' do
            expect(errors).not_to receive(:add).with(attribute, :invalid_verification_digit)
            cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
          end
        end
      end

      context 'when cpf has valid verifying digit' do
        let(:valid_cpf_digits) { true }

        it 'accepts that document verification digit' do
          expect(errors).not_to receive(:add).with(attribute, :invalid_verification_digit)
          cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
        end
      end
    end

    describe 'messaging' do
      let(:attr_value) { '1234556' }

      before do
        allow(BraDocuments::Matcher).to receive(:match?).and_return(valid_format)
        allow(BraDocuments::CPFGenerator).to receive(:valid_verification_digit?).and_return(valid_verification_digit)
        allow(BraDocuments::CNPJGenerator).to receive(:valid_verification_digit?).and_return(valid_verification_digit)
      end

      context 'when no custom message is given' do
        subject(:cpf_or_cnpj_validator) { described_class.new(attributes: [attribute]) }

        context 'and format is invalid' do
          let(:valid_format) { false }
          let(:valid_verification_digit) { false }

          it 'appoints default invalid format message' do
            expect(errors).to receive(:add).with(attribute, :invalid_format)
            cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
          end
        end

        context 'and format is valid' do
          let(:valid_format) { true }

          context 'and verification digit' do
            let(:valid_verification_digit) { false }

            it 'appoints default invalid verification digit message' do
              expect(errors).to receive(:add).with(attribute, :invalid_verification_digit)
              cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end
        end
      end

      context 'when a custom message is given' do
        subject(:cpf_or_cnpj_validator) { described_class.new(attributes: [attribute], message: :invalid) }

        context 'and format is invalid' do
          let(:valid_format) { false }
          let(:valid_verification_digit) { false }

          it 'appoints the custom message error' do
            expect(errors).to receive(:add).with(attribute, :invalid)
            cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
          end
        end

        context 'and format is valid' do
          let(:valid_format) { true }

          context 'and verification digit' do
            let(:valid_verification_digit) { false }

            it 'appoints the custom message error' do
              expect(errors).to receive(:add).with(attribute, :invalid)
              cpf_or_cnpj_validator.validate_each(record, attribute, attr_value)
            end
          end
        end
      end
    end
  end
end
