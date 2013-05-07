require 'test_helper'
require 'facebokr/shell_support/command'

include Facebokr::ShellSupport

class TestCommand < FacebokrTestCase
  test "has name as an CommandName instance" do
    assert_instance_of CommandName, command("hello", proc { |*| }).name
  end

  test "can't be created without proc" do
    assert_raises ArgumentError, "command proc is required" do
      command("foo", nil)
    end
  end

  test "is callable" do
    called = false
    c = command("foo", proc { |*| called = true })
    c.call
    assert called, "expected command block to be called"
  end

  private

  def command(*args)
    Command.new(*args)
  end
end

