# frozen_string_literal: true

module BraDocumentValidation
  class CNPJValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      return record.errors.add(attribute, error_message(:invalid_format)) unless valid_format?(value)

      record.errors.add(attribute, error_message(:invalid_verification_digit)) unless valid_verification_digit?(value)
    end

    private

    def valid_format?(document)
      BraDocuments::Matcher.match?(document.to_s, kind: :cnpj, mode: document_format)
    end

    def valid_verification_digit?(document)
      BraDocuments::CNPJGenerator.valid_verification_digit?(document: document.to_s)
    end

    def document_format
      options[:formatted] ? :formatted : :raw
    end

    def error_message(default_message)
      options.fetch(:message, default_message)
    end
  end
end
