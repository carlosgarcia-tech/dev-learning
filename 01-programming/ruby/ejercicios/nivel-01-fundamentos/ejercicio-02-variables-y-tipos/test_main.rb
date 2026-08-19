require "minitest/autorun"

class TestEjercicio02 < Minitest::Test
  def test_main_ejecuta_sin_errores
    output = capture_io do
      load File.expand_path("main.rb", __dir__)
    end

    combined = output.join
    refute_empty combined, "Se esperaba que main.rb produjera salida por consola"
  end
end
