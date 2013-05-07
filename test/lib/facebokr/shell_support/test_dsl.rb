require 'test_helper'
require 'facebokr/shell_support/dsl'

include Facebokr::ShellSupport

class TestDsl < FacebokrTestCase
  test ".command creates a command" do
    command = fake do
      command "foo" do
      end
    end.commands.find_by_name_or_alias("foo")
    assert command, "expected command 'foo' to be defined"
  end

  private

  def fake(*args, &block)
    Class.new do
      include DSL
      instance_eval(&block)
    end
  end
end

