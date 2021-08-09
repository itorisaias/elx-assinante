defmodule Prepago do
  @moduledoc """
  Modulo de prepago
  """

  defstruct creditos: 0, recargas: []

  @preco_minuto 1.45

  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    custo = @preco_minuto * duracao

    cond do
      custo <= assinante.plano.creditos ->
        plano = assinante.plano
        plano = %__MODULE__{plano | creditos: plano.creditos - custo}

        %Assinante{assinante | plano: plano}
        |> Chamada.registrar(data, duracao)

        {:ok, "A chamada custo #{custo}, e voce tem #{plano.creditos} de creditos"}

      true ->
        {:error, "Voce não tem creditos"}
    end
  end

  def imprimir_conta(month, year, numero) do
    Contas.imprimir(month, year, numero, :prepago)
  end
end
