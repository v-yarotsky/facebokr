require 'test_helper'
require 'facebokr/shell_support/command_name'

include Facebokr::ShellSupport

class TestCommandName < FacebokrTestCase
  test "can not be created with blank name" do
    assert_raises ArgumentError, "command name can't be blank" do
      command_name(nil)
    end
  end

  test "CommandName instance is equal to itself" do
    n = command_name("foo")
    assert_equal n, n
  end

  test "CommandName instances are equal if both name and aliases are equal" do
    assert_equal command_name("foo"), command_name("foo")
    assert_equal command_name("foo", ["baz"]), command_name("foo", ["baz"])
  end

  test "CommandName instances are not equal if names aren't equal" do
    refute_equal command_name("foo"), command_name("bar")
  end

  test "CommandName instances are not equal if aliases aren't equal" do
    refute_equal command_name("foo", ["baz"]), command_name("foo", ["qux"])
  end

  test "CommandName instance is equal to a string if the string is a command's name" do
    assert_equal command_name("foo"), "foo"
  end

  test "CommandName instance is equal to a string if the string is one of command's aliases" do
    assert_equal command_name("foo", ["bar", "baz"]), "bar"
    assert_equal command_name("foo", ["bar", "baz"]), "baz"
  end

  test "CommandName instance is not equal to a string if the string is neither command's name nor one of command's aliases" do
    refute_equal command_name("foo", ["bar", "baz"]), "qux"
  end

  private

  def command_name(*args)
    CommandName.new(*args)
  end
end

