defmodule SmartCity.SchemaGenerator do
  def generate_schema(data) do
    extract_field({:top, data |> hd()}) |> Map.get("subSchema")
  end

  defp extract_field({key, value}) when is_list(value) do
    item_type =
      value
      |> List.first()
      |> infer_type()

    case item_type do
      "map" ->
        schema = List.first(value) |> Enum.map(&extract_field/1)
        schema_field_list("list", key, item_type, schema)

      _ ->
        schema_field_list("list", key, item_type)
    end
  end

  defp extract_field({key, value}) when is_map(value) do
    schema = Enum.map(value, &extract_field/1)
    infer_type(value) |> schema_field(key, schema)
  end

  defp extract_field({key, value}) do
    infer_type(value) |> schema_field(key)
  end

  # This should eventually handle different data types. Sticking to strings as an MVP
  defp infer_type(value) when is_list(value), do: "list"
  defp infer_type(value) when is_map(value), do: "map"
  defp infer_type(_), do: "string"

  defp schema_field_list(type, name, item_type) when type == "list" do
    %{
      "biased" => "No",
      "demographic" => "None",
      "description" => "",
      "masked" => "N/A",
      "name" => name,
      "pii" => "None",
      "type" => type,
      "itemType" => item_type
    }
  end

  defp schema_field_list(type, name, item_type, schema) when type == "list" and item_type == "map" do
    %{
      "biased" => "No",
      "demographic" => "None",
      "description" => "",
      "masked" => "N/A",
      "name" => name,
      "pii" => "None",
      "type" => type,
      "itemType" => item_type,
      "subSchema" => schema
    }
  end

  defp schema_field(type, name, schema) when type == "map" do
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
