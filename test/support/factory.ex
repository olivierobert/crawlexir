defmodule Crawlexir.Factory do
  use ExMachina.Ecto, repo: Crawlexir.Repo

  use Crawlexir.KeywordFactory
  use Crawlexir.ReportFactory
  use Crawlexir.UserFactory
end
