
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Update `bra_documents` dependency to `>= 1.1.0` for alphanumeric CNPJ support
- Update CNPJ validator to support alphanumeric format as per new Brazilian Federal Revenue regulation (effective July 2026)
  - Reference: https://www.gov.br/receitafederal/pt-br/assuntos/noticias/2024/outubro/cnpj-tera-letras-e-numeros-a-partir-de-julho-de-2026

### Added

- Add IRB as development dependency
- Add binstubs for rake and rspec

## [1.0.2] - 2022-01-04

### Removed

- Drop Support for Ruby 2.6 or less

### Refactory

- Refactory CPF and CNPJ Validators to use new bra_documents's methods

### Added

- Add new validator to check if an attribute is a CPF or a CNPJ

## [1.0.1] - 2020-11-08

### Fixed

- Fix Gemfile lock

## [1.0.0] - 2020-11-08

### Added

- CPF and CNPJ Validators
