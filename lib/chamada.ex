defmodule Chamada do
  @moduledoc """
  Modulo de registro de chamadas
  """

  defstruct date: nil, duracao: nil

  @doc """
  Funcao para registrar as chamadas realizas
  """
  def registrar(assinante, data, duracao) do
    assinante_atualizado = %Assinante{
      assinante
      | chamadas: assinante.chamadas ++ %__MODULE__{date: data, duracao: duracao}
    }

    Assinante.atualizar(assinante.numero, assinante_atualizado)
  end
end
