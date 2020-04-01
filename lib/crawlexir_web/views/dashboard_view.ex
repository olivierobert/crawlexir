defmodule CrawlexirWeb.DashboardView do
  use CrawlexirWeb, :view

  def show_keyword_list?(conn) do
    conn.assigns.keywords |> Enum.any?()
  end
end
