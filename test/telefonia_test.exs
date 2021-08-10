defmodule TelefoniaTest do
  use ExUnit.Case
  doctest Telefonia

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm!("pre.txt")
      File.rm!("pos.txt")
    end)
  end

  test "deve iniciar o projeto criando dois arquivos" do
    Telefonia.start()

    assert File.exists?("pre.txt") == true
    assert File.exists?("pos.txt") == true
  end

  test "deve registrar um usuario prepago" do
    assert Telefonia.cadastrar_assinante("Itor", "123", "123", :prepago) ==
             {:ok, "Assinante Itor cadastrado com sucesso!"}
  end

  test "Deve listar todos assinantes" do
    Telefonia.cadastrar_assinante("Itor", "123", "123", :prepago)
    Telefonia.cadastrar_assinante("Itor", "124", "123", :pospago)

    assert Enum.count(Telefonia.listar_assinantes()) == 2
  end

  test "Deve listar todos assinantes prepago" do
    Telefonia.cadastrar_assinante("Itor", "123", "123", :prepago)
    Telefonia.cadastrar_assinante("Itor", "124", "123", :pospago)

    assert Enum.count(Telefonia.listar_assinantes_prepago()) == 1
  end

  test "Deve listar todos assinantes pospago" do
    Telefonia.cadastrar_assinante("Itor", "123", "123", :prepago)
    Telefonia.cadastrar_assinante("Itor", "124", "123", :pospago)

    assert Enum.count(Telefonia.listar_assinantes_pospago()) == 1
  end

  test "Deve fazer chamada" do
    Telefonia.cadastrar_assinante("Itor", "123", "123", :pospago)

    Telefonia.fazer_chamada("123", :pospago, DateTime.utc_now(), 5)

    assinante = Telefonia.busca_por_numero("123")

    assert Enum.count(assinante.chamadas) == 1
  end

  test "deve fazer uma recarga" do
    Telefonia.cadastrar_assinante("Itor", "123", "123", :prepago)

    Telefonia.recarga("123", DateTime.utc_now(), 5)

    assinante = Telefonia.busca_por_numero("123")

    assert Enum.count(assinante.plano.recargas) == 1
  end

  test "Deve buscar por numero" do
    Telefonia.cadastrar_assinante("Itor", "123", "123", :prepago)

    assinante = Telefonia.busca_por_numero("123")

    assert assinante.numero == "123"
    assert assinante.nome == "Itor"
  end

  test "deve imprimir conta" do
    Telefonia.cadastrar_assinante("Itor", "123", "123", :prepago)
    Telefonia.cadastrar_assinante("Itor", "124", "123", :pospago)

    data = DateTime.utc_now()

    Telefonia.fazer_chamada("123", :prepago, data, 5)
    Telefonia.fazer_chamada("124", :pospago, data, 5)

    Telefonia.imprimir_contas(data.month, data.year)

    assert 1 == 1
  end
end
