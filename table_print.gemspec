# -*- encoding: utf-8 -*-
require File.expand_path('../lib/table_print/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'table_print'
  s.version = TablePrint::VERSION
  s.date = '2016-08-13'
  s.summary = 'Print Ruby enumerables in MySQL table style'
  s.authors = ['Kyle Tate']
  s.email = 'kbt.tate@gmail.com'

  s.files = Dir.glob("{lib}/**/*")

  s.require_paths = ["lib"]

  s.add_development_dependency 'minitest', '~>5.8'
  s.add_development_dependency 'rake', '~>10.0'

  s.homepage    = 'https://github.com/infiton/table_print'
  s.license     = 'MIT'
end
