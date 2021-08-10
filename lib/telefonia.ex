defmodule Telefonia do
  @moduledoc """
  Função que inicia o projeto deve sempre ser chamada antes de usar o projeto
  """

  @doc """
  Funcao para iniciar o projeto

  ## Exemplo

      iex> Telefonia.start()
      :ok
  """
  def start do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))
  end

  @doc """
  Função para cadastrar assinantes, seja ele `prepago` e `pospago`

  ## Parametros da função

  - nome: parametro do nome do assinantes
  - numero: numero unico e caso exista pode retornar um erro
  - cpf: parametro do CPF assinantes
  - plano: plano desejado sendo eles `:prepago` ou `:pospago`

  ## Exemplo

      iex> Assinante.cadastrar("Maria", "123123", "123456789", :prepago)
      {:ok, "Assinante Maria cadastrado com sucesso!"}
  """
  def cadastrar_assinante(nome, numero, cpf, plano) do
    Assinante.cadastrar(nome, numero, cpf, plano)
  end

  def listar_assinantes, do: Assinante.assinantes()
  def listar_assinantes_prepago, do: Assinante.assinantes_prepago()
  def listar_assinantes_pospago, do: Assinante.assinantes_pospago()

  def fazer_chamada(numero, plano, data, duracao) do
    cond do
      plano == :prepago ->
        Prepago.fazer_chamada(numero, data, duracao)

      plano == :pospago ->
        Pospago.fazer_chamada(numero, data, duracao)
    end
  end

  def recarga(numero, data, valor), do: Recarga.nova(data, valor, numero)
  def busca_por_numero(numero, plano \\ :all), do: Assinante.buscar_assinante(numero, plano)

  def imprimir_contas(mes, ano) do
    Assinante.assinantes_prepago()
    |> Enum.each(fn assinante ->
      assinante = Prepago.imprimir_conta(mes, ano, assinante.numero)
      IO.puts("Conta Prepaga do Assinante: #{assinante.nome}")
      IO.puts("Numero: #{assinante.numero}")
      IO.puts("Chamadas:")
      IO.inspect(assinante.chamadas)
      IO.puts("Recargas: ")
      IO.inspect(assinante.plano.recargas)
      IO.puts("Total de chamadas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Total de recargas: #{Enum.count(assinante.plano.recargas)}")
      IO.puts("-----------------------------------------------------")
    end)

    Assinante.assinantes_pospago()
    |> Enum.each(fn assinante ->
      assinante = Pospago.imprimir_conta(mes, ano, assinante.numero)
      IO.puts("Conta Pospago do Assinante: #{assinante.nome}")
      IO.puts("Numero: #{assinante.numero}")
      IO.puts("Chamadas:")
      IO.inspect(assinante.chamadas)
      IO.puts("Total de chamadas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Valor da fatura: #{assinante.plano.valor}")
      IO.puts("-----------------------------------------------------")
    end)
  end
end
