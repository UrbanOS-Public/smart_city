defmodule SmartCity.SchemaGenerator do
  @moduledoc """
  Take the first row of data from a datasample and generates an implied schema from that with all field types being strings. Lists and nested maps are generated with their subschemas where applicable.
  """
  @base_schema %{"biased" => "No", "demographic" => "None", "description" => "", "masked" => "N/A", "pii" => "None"}
  def generate_schema(data) do
    extract_field({:top, data |> hd()}) |> Map.get("subSchema")
  end

  def extract_field({key, value}) when is_list(value) do
    item_type =
      value
      |> List.first()
      |> infer_type()

    case item_type do
      "map" ->
        schema = List.first(value) |> Enum.map(&extract_field/1)
        schema_field_list("list", key, item_type, schema)

      "list" ->
        sub_schema = [extract_field({"child_of_list", List.first(value)})]
        schema_field_list("list", key, item_type, sub_schema)

      _ ->
        schema_field_list("list", key, item_type)
    end
  end

  def extract_field({key, value}) when is_map(value) do
    schema = Enum.map(value, &extract_field/1)
    infer_type(value) |> schema_field(key, schema)
  end

  def extract_field({key, value}) do
    infer_type(value) |> schema_field(key)
  end

  def extract_field(list) do
    List.first(list)
    |> infer_type
    |> schema_field("child_of_list")
  end

  defp infer_type(value) when is_list(value), do: "list"
  defp infer_type(value) when is_map(value), do: "map"
  defp infer_type(value) when is_integer(value), do: "integer"
  defp infer_type(value) when is_float(value), do: "float"
  defp infer_type(value) when is_boolean(value), do: "boolean"

  defp infer_type(value) do
    cond do
      is_timestamp(value) -> "timestamp"
      is_date(value) -> "date"
      true -> "string"
    end
  end

  defp is_timestamp(value) do
    case Timex.parse(value, "{ISO:Extended}") do
      {:ok, _} -> true
      _ -> false
    end
  end

  defp is_date(value) do
    case Timex.parse(value, "{ISOdate}") do
      {:ok, _} -> true
      _ -> false
    end
  end

  defp schema_field_list(type, name, item_type) when type == "list" do
    %{
      "name" => name,
      "type" => type,
      "itemType" => item_type,
      "ingestion_field_selector" => name
    }
    |> Map.merge(@base_schema)
  end

  defp schema_field_list(type, name, item_type, sub_schema) when type == "list" and item_type == "list" do
    %{
      "name" => name,
      "type" => type,
      "itemType" => item_type,
      "subSchema" => sub_schema,
      "ingestion_field_selector" => name
    }
    |> Map.merge(@base_schema)
  end

  defp schema_field_list(type, name, item_type, schema) when type == "list" and item_type == "map" do
    %{
      "name" => name,
      "type" => type,
      "itemType" => item_type,
      "subSchema" => schema,
      "ingestion_field_selector" => name
    }
    |> Map.merge(@base_schema)
  end

  defp schema_field(type, name, schema) when type == "map" do
    %{
      "name" => name,
      "type" => type,
      "subSchema" => schema,
      "ingestion_field_selector" => name
    }
    |> Map.merge(@base_schema)
  end

  defp schema_field(type, name) do
    %{
      "biased" => "No",
      "demographic" => "None",
      "description" => "",
      "masked" => "N/A",
      "name" => name,
      "pii" => "None",
      "type" => type,
      "ingestion_field_selector" => name
    }
  end
end
