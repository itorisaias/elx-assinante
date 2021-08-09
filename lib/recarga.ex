defmodule Recarga do
  defstruct date: nil, valor: nil

  @doc """
  Funcao para realizar recarga

  ## Parametros

  - data: a data que esta sendo realizada a chamada
  - valor: valor da recarga
  - numero: o numero que deseja recarregar (apenas usuario do `:prepago`)

  ## Exemplo

      iex> Assinante.cadastrar("Itor", "123456", "43214213", :prepago)
      {:ok, "Assinante Itor cadastrado com sucesso!"}
      iex> Recarga.nova(DateTime.utc_now(), 10, "123456")
      {:ok, "Recarga realizada com sucesso"}
  """
  def nova(data, valor, numero) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    plano = assinante.plano

    plano = %Prepago{
      plano
      | creditos: plano.creditos + valor,
        recargas: plano.recargas ++ [%__MODULE__{date: data, valor: valor}]
    }

    assinante = %Assinante{assinante | plano: plano}

    Assinante.atualizar(assinante.numero, assinante)

    {:ok, "Recarga realizada com sucesso"}
  end
end
