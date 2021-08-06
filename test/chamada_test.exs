defmodule ChamadaTest do
  use ExUnit.Case
  doctest Chamada

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm!("pre.txt")
      File.rm!("pos.txt")
    end)
  end

  test "deve validar a estrutura" do
    assert %Chamada{date: DateTime.utc_now(), duracao: 30}.duracao == 30
  end
end
