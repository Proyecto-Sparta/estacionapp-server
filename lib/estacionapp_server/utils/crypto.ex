defmodule EstacionappServer.Utils.Crypto do
  @moduledoc """
  Module that gathers all password generation/encyptation related utils
  """
  @spec encrypt(String.t) :: String.t
  def encrypt(text), do: Cipher.encrypt(text)

  @spec decrypt(String.t) :: String.t
  def decrypt(text), do: Cipher.decrypt(text)
end
