defmodule Chamada do
  @moduledoc """
  Modulo de registro de chamadas
  """

  defstruct date: nil, duracao: nil

  @doc """
  Funcao para registrar as chamadas realizas

  ## Parametros

  - assinante: o assinante que está realizando a chamada (%Assinante{}})
  - data: a data de realização da chamada
  - duracao: o tempo de duração da chamada

  ## Exemplo

      iex> Assinante.cadastrar("Maria", "123123", "123456789", :pospago)
      {:ok, "Assinante Maria cadastrado com sucesso!"}
      iex> Assinante.buscar_assinante("123123") |> Chamada.registrar(DateTime.utc_now, 1)
      :ok
  """
  def registrar(assinante, data, duracao) do
    assinante_atualizado = %Assinante{
      assinante
      | chamadas: assinante.chamadas ++ %__MODULE__{date: data, duracao: duracao}
    }

    Assinante.atualizar(assinante.numero, assinante_atualizado)
  end
end
