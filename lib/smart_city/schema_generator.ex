defmodule SmartCity.SchemaGenerator do

  def generate_schema(data) do
    extract_field({:top, data |> hd()}) |> Map.get("subSchema")
  end

  defp extract_field({key, value}) when is_map(value) do
    schema = Enum.map(value, &extract_field/1)
    infer_type(value) |> schema_field(key, schema)
  end

  defp extract_field({key, value}) do
    infer_type(value) |> schema_field(key)
  end

  defp infer_type(value) when is_map(value), do: "map"
  defp infer_type(value) when is_integer(value), do: "integer"
  defp infer_type(_), do: "string"

  defp schema_field(type, name, schema)  when type == "map" do
    %{
      "biased" => "No",
      "demographic" => "None",
      "description" => "",
      "masked" => "N/A",
      "name" => name,
      "pii" => "None",
      "type" => type,
      "subSchema" => schema
    }
  end

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
