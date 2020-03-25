defmodule CrawlexirWeb.LayoutView do
  use CrawlexirWeb, :view

  def body_class(conn) do
    "#{module_class_name(conn)} #{action_name(conn)}"
  end

  defp module_class_name(conn) do
    controller_module(conn)
    |> Atom.to_string
    |> String.split(".")
    |> List.last
    |> String.downcase
    |> String.replace("controller", "")
  end
end
