defmodule PospagoTest do
  use ExUnit.Case
  doctest Pospago

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm!("pre.txt")
      File.rm!("pos.txt")
    end)
  end

  test "deve fazer uma ligacao" do
    Assinante.cadastrar("Itor", "123456", "43214213", :pospago)

    Pospago.fazer_chamada("123456", DateTime.utc_now(), 5) ==
      {:ok, "Chamada feita com sucesso, duracao 5 minutos"}
  end

  describe "Testes para impressao de contas" do
    test "deve informar valores da conta do mes" do
      numero = "123456"
      data = DateTime.utc_now()
      data_antiga = ~U[2021-06-06 22:28:41.481768Z]

      Assinante.cadastrar("Itor", numero, "43214213", :pospago)
      Pospago.fazer_chamada(numero, data, 3)
      Pospago.fazer_chamada(numero, data, 2)
      Pospago.fazer_chamada(numero, data_antiga, 3)
      Pospago.fazer_chamada(numero, data_antiga, 2)

      assinante = Assinante.buscar_assinante(numero, :pospago)
      assert Enum.count(assinante.chamadas) == 4

      relatorio = Pospago.imprimir_conta(data.month, data.year, numero)

      assert relatorio.numero == numero
      assert Enum.count(relatorio.chamadas) == 2
      assert relatorio.plano.valor == 6.999999999999999
    end
  end
end
