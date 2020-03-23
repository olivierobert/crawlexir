defmodule Crawlexir.Auth.Password do
  alias Crawlexir.Auth.User

  def hash_password(password), do: Argon2.hash_pwd_salt(password)

  def validate_password(%User{} = user, password), do: Argon2.check_pass(user, password)
end