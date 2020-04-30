defmodule SerialKiller.Hinter do
  def data(query) do
    Postgrex.query!(
      DB,
      "SELECT title, id, start_year FROM shows WHERE LOWER(title) LIKE LOWER('#{query}%%') LIMIT 10;",
      [],
      [pool: DBConnection.ConnectionPool]
    )
    |> SerialKiller.Hinter.result_to_maps
  end

  def result_to_maps(%Postgrex.Result{columns: _, rows: nil}), do: []

  # FIXME: move it to helpers?
  def result_to_maps(%Postgrex.Result{columns: col_nms, rows: rows}) do
    Enum.map(rows, fn(row) -> row_to_map(col_nms, row) end)
  end

  defp row_to_map(col_nms, vals) do
    Stream.zip(col_nms, vals)
    |> Enum.into(Map.new(), &(&1))
  end
end
