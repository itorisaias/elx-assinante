defmodule AssinanteTest do
  use ExUnit.Case

  doctest Assinante

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm!("pre.txt")
      File.rm!("pos.txt")
    end)
  end

  test "validate struc" do
    assert %Assinante{nome: "itor", cpf: "123", numero: "123"}.nome == "itor"
  end

  describe "Testes Assinante.cadastrar" do
    test "criar uma conta prepago" do
      assert Assinante.cadastrar("Itor", "123456", "43214213", :prepago) ==
               {:ok, "Assinante Itor cadastrado com sucesso!"}
    end

    test "deve retornar erro dizendo que assinante ja esta cadastrado" do
      Assinante.cadastrar("Itor", "123456", "43214213", :prepago)

      assert Assinante.cadastrar("Itor", "123456", "43214213", :prepago) ==
               {:error, "Assinante com este numero já existe!"}
    end
  end

  describe "Teste Assinante.buscar_assinante" do
    test "Buscar all" do
      Assinante.cadastrar("Itor", "123456", "43214213", :prepago)
      assert Assinante.buscar_assinante("123456").nome == "Itor"
    end

    test "Buscar prepago" do
      Assinante.cadastrar("Itor", "123456", "43214213", :prepago)
      assert Assinante.buscar_assinante("123456", :prepago).nome == "Itor"
      assert Assinante.buscar_assinante("123456", :prepago).plano.__struct__ == Prepago
    end

    test "Buscar pospago" do
      Assinante.cadastrar("Itor", "123456", "43214213", :pospago)
      assert Assinante.buscar_assinante("123456", :pospago).nome == "Itor"
      assert Assinante.buscar_assinante("123456", :pospago).plano.__struct__ == Pospago
    end
  end

  describe "delete" do
    test "deve deletar o assinante" do
      Assinante.cadastrar("Itor", "123456", "43214213", :pospago)
      Assinante.cadastrar("Vitor", "123457", "43214213", :pospago)
      assert Assinante.deletar("123456") == {:ok, "Assinante Itor deletado!"}
    end
  end
end
