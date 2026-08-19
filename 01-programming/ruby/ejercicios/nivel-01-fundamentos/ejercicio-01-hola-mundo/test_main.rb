require "minitest/autorun"
require "stringio"

class TestHolaMundo < Minitest::Test
  def test_salida
    output = capture_io do
      load File.expand_path("main.rb", __dir__)
    end

    combined = output.join
    assert_includes combined, "Hola, mundo"
    assert_includes combined, "Mi nombre es"
  end
end
