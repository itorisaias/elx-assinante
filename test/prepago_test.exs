defmodule PrepagoTest do
  use ExUnit.Case
  doctest Prepago

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm!("pre.txt")
      File.rm!("pos.txt")
    end)
  end

  describe "Funções de ligação" do
    test "fazer uma ligação" do
      Assinante.cadastrar("Itor", "123456", "43214213", :prepago)

      assert Prepago.fazer_chamada("123456", DateTime.utc_now(), 3) ==
               {:ok, "A chamada custo 4.35, e voce tem 5.65 de creditos"}
    end

    test "fazer uma ligação longa e não tem creditos" do
      Assinante.cadastrar("Itor", "123456", "43214213", :prepago)

      assert Prepago.fazer_chamada("123456", DateTime.utc_now(), 10) ==
               {:error, "Voce não tem creditos"}
    end
  end
end
