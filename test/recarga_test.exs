defmodule RecargaTest do
  use ExUnit.Case
  doctest Recarga

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm!("pre.txt")
      File.rm!("pos.txt")
    end)
  end

  test "deve validar a estrutura" do
    assert %Recarga{date: DateTime.utc_now(), valor: 10}.valor == 10
  end

  test "deve realizar uma recarga" do
    Assinante.cadastrar("Itor", "123456", "43214213", :prepago)

    assert Recarga.nova(DateTime.utc_now(), 30, "123456") ==
             {:ok, "Recarga realizada com sucesso"}

    assinante = Assinante.buscar_assinante("123456")

    assert assinante.plano.creditos == 30
    assert Enum.count(assinante.plano.recargas) == 1
  end
end
