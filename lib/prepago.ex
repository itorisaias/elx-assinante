defmodule Prepago do
  @moduledoc """
  Modulo de prepago
  """

  defstruct creditos: 10, recargas: []

  @preco_minuto 1.45

  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    custo = @preco_minuto * duracao

    cond do
      custo <= assinante.plano.creditos ->
        plano = assinante.plano
        plano = %__MODULE__{plano | creditos: plano.creditos - custo}
        assinante = %Assinante{assinante | plano: plano}
        {:ok, "A chamada custo #{custo}, e voce tem #{plano.creditos} de creditos"}

      true ->
        {:error, "Voce não tem creditos"}
    end
  end
end
