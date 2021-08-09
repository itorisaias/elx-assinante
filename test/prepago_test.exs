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
      Recarga.nova(DateTime.utc_now(), 10, "123456")

      assert Prepago.fazer_chamada("123456", DateTime.utc_now(), 3) ==
               {:ok, "A chamada custo 4.35, e voce tem 5.65 de creditos"}
    end

    test "fazer uma ligação longa e não tem creditos" do
      Assinante.cadastrar("Itor", "123456", "43214213", :prepago)

      assert Prepago.fazer_chamada("123456", DateTime.utc_now(), 10) ==
               {:error, "Voce não tem creditos"}
    end
  end

  describe "Testes para impressao de contas" do
    test "deve informar valores da conta do mes" do
      numero = "123456"
      Assinante.cadastrar("Itor", numero, "43214213", :prepago)

      data = DateTime.utc_now()
      Recarga.nova(data, 10, numero)
      Prepago.fazer_chamada(numero, data, 3)

      data_antiga = ~U[2021-06-06 22:28:41.481768Z]
      Recarga.nova(data_antiga, 10, numero)
      Prepago.fazer_chamada(numero, data_antiga, 3)

      assinante = Assinante.buscar_assinante(numero, :prepago)
      assert Enum.count(assinante.chamadas) == 2
      assert Enum.count(assinante.plano.recargas) == 2

      relatorio = Prepago.imprimir_conta(data.month, data.year, numero)

      assert relatorio.numero == numero
      assert Enum.count(relatorio.chamadas) == 1
      assert Enum.count(relatorio.plano.recargas) == 1
    end
  end
end
