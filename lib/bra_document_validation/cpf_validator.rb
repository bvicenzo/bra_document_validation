# frozen_string_literal: true

module BraDocumentValidation
  class CPFValidator < ActiveModel::EachValidator
    FORMATTED_CPF_PATTERN = /^(\d{3}\.\d{3}\.\d{3})-(\d{2})$/
    RAW_CPF_PATTERN = /\A\d{11}\z/
    NOT_NUMBER_PATTERN = /\D/

    def validate_each(record, attribute, value)
      return record.errors.add(attribute, error_message(:invalid_format)) unless document_format.match?(value.to_s)

      full_number = only_numbers_for(value.to_s)

      return unless black_listed?(full_number) || !digit_verified?(full_number)

      record.errors.add(attribute, error_message(:invalid_verification_digit))
    end

    private

    def digit_verified?(number)
      person_number = number_without_verifying_digits_for(number)

      number == BraDocuments::CPFGenerator.generate(person_number: person_number)
    end

    def number_without_verifying_digits_for(number)
      number.chars.shift(BraDocuments::CPFGenerator::PERSON_NUMBER_SIZE).join
    end

    def only_numbers_for(value)
      value.gsub(NOT_NUMBER_PATTERN, '')
    end

    def black_listed?(number)
      number.chars.uniq.size == 1
    end

    def document_format
      options[:formatted] ? FORMATTED_CPF_PATTERN : RAW_CPF_PATTERN
    end

    def error_message(default_message)
      options.fetch(:message, default_message)
    end
  end
end
