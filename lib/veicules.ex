defmodule Veicules do
  defstruct name: nil, model: nil, color: nil, year: nil, price: nil

  @colors_enabled ~w[black red green yellow blue]

  def create(name, model, color, year) do
    {:ok,
     %__MODULE__{
       color: color,
       name: name,
       model: model,
       year: year,
       price: nil
     }}
    |> validate_year()
    |> validate_color()
  end

  defp validate_year({:error, _reason} = error), do: error

  defp validate_year({:ok, %Veicules{year: year} = veicule}) do
    case year > 2000 and year < 2020 do
      true -> {:ok, veicule}
      _ -> {:error, "Invalid year"}
    end
  end

  defp validate_color({:error, _reason} = error), do: error

  defp validate_color({:ok, veicule}) do
    case Enum.find(@colors_enabled, fn color -> veicule.color == color end) do
      nil -> {:error, "Invalid color"}
      _ -> {:ok, veicule}
    end
  end
end
