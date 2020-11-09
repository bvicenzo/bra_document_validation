# frozen_string_literal: true

module BraDocumentValidation
  class CNPJValidator < ActiveModel::EachValidator
    FORMATTED_CNPJ_PATTERN = /\A(\d{2}\.\d{3}\.\d{3}\/\d{4})-(\d{2})\Z/.freeze
    RAW_CNPJ_PATTERN = /\A\d{14}\Z/.freeze
    NOT_NUMBER_PATTERN = /\D/.freeze

    def validate_each(record, attribute, value)
      return record.errors.add(attribute, :invalid_format) unless document_format.match?(value.to_s)
      full_number = only_numbers_for(value.to_s)
      record.errors.add(attribute, :invalid_verification_digit) if black_listed?(full_number) || !digit_verified?(full_number)
    end

    private

    def digit_verified?(full_number)
      company_number, matrix_subsidiary_number = numbers_for(full_number)

      full_number == BraDocuments::CNPJGenerator.generate(company_number: company_number, matrix_subsidiary_number: matrix_subsidiary_number)
    end

    def numbers_for(value)
      number = value.gsub(NOT_NUMBER_PATTERN, '').chars

      [
        number.shift(BraDocuments::CNPJGenerator::COMPANY_NUMBER_SIZE).join,
        number.shift(BraDocuments::CNPJGenerator::MATRIX_SUBSIDIARY_SIZE).join
      ]
    end

    def only_numbers_for(value)
      value.gsub(NOT_NUMBER_PATTERN, '')
    end

    def black_listed?(number)
      number.chars.uniq.size == 1
    end

    def document_format
      options[:formatted] ? FORMATTED_CNPJ_PATTERN : RAW_CNPJ_PATTERN
    end
  end
end
