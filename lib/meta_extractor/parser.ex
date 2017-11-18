defmodule MetaExtractor.Parser do
  @meta "meta"
  @name "name"
  @content "content"
  @property "property"

  def parse(content), do: parse(content, %{})

  defp parse(content, state) do
    content
    |> Floki.find(@meta)
    |> process(state)
  end

  def process([], state), do: state
  def process([head|tail], state) do
    head
    |> parse_meta()
    |> fn x -> process(tail, update_state(x, state)) end.()
  end

  defp update_state(:no_content, state), do: state
  defp update_state({key, value}, state), do: Map.put(state, key, value)

  def parse_meta(meta_attr) do
    get_content(Floki.attribute(meta_attr, @name),
                Floki.attribute(meta_attr, @property),
                Floki.attribute(meta_attr, @content))
  end

  def get_content([name], [], [content]) do
    {name, content}
  end

  def get_content([], [property], [content]) do
    {property, content}
  end

  def get_content(_, _, _), do: :no_content
end
