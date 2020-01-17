defmodule SmartCity.SchemaGenerator do

  def generate_schema(data) do
    data
    |> Enum.map(&extract_key/1)
    
  end

  defp extract_key(datum) do
    datum
    |> Enum.map( fn {key, value} -> infer_type(value) |> schema_field(key) end)
  end

  defp infer_type(value) when is_integer(value), do: "integer"
  defp infer_type(_), do: "string"

  defp schema_field(type, name) do
    %{
      "biased" => "No",
      "demographic" => "None",
      "description" => "",
      "masked" => "N/A",
      "name" => name,
      "pii" => "None",
      "type" => type
    }
  end
end
