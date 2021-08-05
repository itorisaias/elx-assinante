defmodule Assinante do
  @moduledoc """
  Modulo de assinante para cadastro de tipos de assinantes como `prepago` e `pospago`

  A função mais utilizada é a função `cadastrar/4`
  """

  defstruct nome: nil, numero: nil, cpf: nil, plano: nil, chamadas: []

  @assinantes_file_name %{:prepago => "pre.txt", :pospago => "pos.txt"}

  @doc """
  Função para listar todos assinantes `prepago`

  ## Exemplo

      iex> Assinante.cadastrar("Maria", "123123", "123456789", :prepago)
      {:ok, "Assinante Maria cadastrado com sucesso!"}
      iex> Assinante.assinantes_prepago()
      [%Assinante{cpf: "123456789", nome: "Maria", numero: "123123", plano: %Prepago{}}]
  """
  def assinantes_prepago(), do: read(:prepago)

  @doc """
  Função para listar todos assinantes `pospago`

  ## Exemplo

      iex> Assinante.cadastrar("Maria", "123123", "123456789", :pospago)
      {:ok, "Assinante Maria cadastrado com sucesso!"}
      iex> Assinante.assinantes_pospago()
      [%Assinante{cpf: "123456789", nome: "Maria", numero: "123123", plano: %Pospago{}}]
  """
  def assinantes_pospago(), do: read(:pospago)

  @doc """
  Função para listar todos assinantes `prepago` e `pospago`

  ## Exemplo

      iex> Assinante.cadastrar("Maria", "123123", "123456789", :pospago)
      {:ok, "Assinante Maria cadastrado com sucesso!"}
      iex> Assinante.cadastrar("Itor", "123124", "123456781", :prepago)
      {:ok, "Assinante Itor cadastrado com sucesso!"}
      iex> Assinante.assinantes()
      [
        %Assinante{cpf: "123456781", nome: "Itor", numero: "123124", plano: %Prepago{}},
        %Assinante{cpf: "123456789", nome: "Maria", numero: "123123", plano: %Pospago{}}
      ]
  """
  def assinantes(), do: read(:prepago) ++ read(:pospago)

  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))
  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)

  @doc """
  Função para buscar assinantes pelo numero e filtro opcional

  ## Parametros da função

  - numero: parametro do numero do telefone
  - key: tipo do plano `:prepago` ou `:pospago`, default é `:all`

  ## Exemplo


      iex> Assinante.cadastrar("Maria", "123123", "123456789", :pospago)
      {:ok, "Assinante Maria cadastrado com sucesso!"}
      iex> Assinante.cadastrar("Itor", "123124", "123456781", :prepago)
      {:ok, "Assinante Itor cadastrado com sucesso!"}
      iex> Assinante.buscar_assinante("123123")
      %Assinante{cpf: "123456789", nome: "Maria", numero: "123123", plano: %Pospago{}}
  """
  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)

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
  def cadastrar(nome, numero, cpf, :prepago), do: cadastrar(nome, numero, cpf, %Prepago{})
  def cadastrar(nome, numero, cpf, :pospago), do: cadastrar(nome, numero, cpf, %Pospago{})

  def cadastrar(nome, numero, cpf, plano) do
    case buscar_assinante(numero) do
      nil ->
        assinante = %__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}

        (read(pega_plano(assinante)) ++ [assinante])
        |> :erlang.term_to_binary()
        |> write(pega_plano(assinante))

        {:ok, "Assinante #{nome} cadastrado com sucesso!"}

      _assinante ->
        {:error, "Assinante com este numero já existe!"}
    end
  end

  defp pega_plano(assinante) do
    case assinante.plano.__struct__ === Prepago do
      true -> :prepago
      false -> :pospago
    end
  end

  defp write(lista_assinantes, plano) do
    File.write!(@assinantes_file_name[plano], lista_assinantes)
  end

  defp read(plano) do
    case File.read(@assinantes_file_name[plano]) do
      {:ok, assinantes} -> assinantes |> :erlang.binary_to_term()
      _ -> {:error, "Plano não existe"}
    end
  end

  @doc """
  Função para deletar assinante pelo numero

  ## Parametros da função

  - numero: numero do telefone do usuario desejado

  ## Exemplo

      iex> Assinante.cadastrar("Maria", "123123", "123456789", :pospago)
      {:ok, "Assinante Maria cadastrado com sucesso!"}
      iex> Assinante.deletar("123123")
      {:ok, "Assinante Maria deletado!"}
  """
  def deletar(numero) do
    {assinante, nova_lista} = deletar_item(numero)

    nova_lista
    |> :erlang.term_to_binary()
    |> write(pega_plano(assinante))

    {:ok, "Assinante #{assinante.nome} deletado!"}
  end

  defp deletar_item(numero) do
    assinante = buscar_assinante(numero)

    nova_lista =
      read(pega_plano(assinante))
      |> List.delete(assinante)

    {assinante, nova_lista}
  end

  @doc """
  Função para atualizar o assinante

  ## Parametros

  - numero: numero do assinante
  - assinante: novo payload do usuario

  ## Exemplo
  """
  def atualizar(numero, assinante) do
    {assinante_antigo, nova_lista} = deletar_item(numero)

    case assinante.plano.__struct__ == assinante_antigo.plano.__struct__ do
      true ->
        (nova_lista ++ [assinante])
        |> :erlang.term_to_binary()
        |> write(pega_plano(assinante))

      false ->
        {:error, "Assinante não pode alterar o plano"}
    end
  end
end
