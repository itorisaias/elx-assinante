defmodule TelefoniaTest do
  use ExUnit.Case
  doctest Telefonia

  test "deve iniciar o projeto criando dois arquivos" do
    Telefonia.start()

    assert File.exists?("pre.txt") == true
    assert File.exists?("pos.txt") == true
  end

  test "deve registrar um usuario prepago" do
    assert Telefonia.cadastrar_assinante("Itor", "123", "123", :prepago) ==
             {:ok, "Assinante Itor cadastrado com sucesso!"}
  end
end
