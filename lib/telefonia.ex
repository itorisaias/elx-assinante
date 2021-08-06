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
end
