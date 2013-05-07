require 'test_helper'
require 'facebokr/shell_support/input_parser'

include Facebokr::ShellSupport

class TestInputParser < FacebokrTestCase

  private

  def parser(*args)
    InputParser.new(*args)
  end
end


