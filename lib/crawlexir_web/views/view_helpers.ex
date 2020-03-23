defmodule CrawlexirWeb.ViewHelpers do
  @moduledoc """
  Conveniences for rendering views and components.
  """

  def render_shared(template, assigns \\ []) do
    Phoenix.View.render(CrawlexirWeb.SharedView, template, assigns)
  end
end
