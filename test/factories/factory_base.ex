defmodule Crawlexir.FactoryBase do
  #  @callback insert_method(attrs :: term) ::

  defmacro __using__(_) do
    quote do
      @doc """
      Returns a Struct for a given factory.

      ## Examples

          iex> build(:user, %{name: "John"})
          %User{name: "John"}
      """
      def build(factory_name, attributes) do
        factory_name |> build() |> struct(attributes)
      end

      @doc """
      Returns a Map for a given factory.

      ## Examples

          iex> build(:user, %{name: "John"})
          %{name: "John"}
      """
      def build_attributes(factory_name, attributes \\ %{}) do
        build(factory_name, attributes) |> Map.from_struct()
      end

      @doc """
      Returns a for a given factory.

      ## Examples

          iex> insert!(:user, %{name: "John"})
          %User{name: "John"}
      """
      def insert!(factory_name, attributes \\ %{}) do
        Crawlexir.Repo.insert!(build(factory_name, attributes))
      end

      defoverridable insert!: 2
    end
  end
end
