defmodule EstacionappServer.LoginAuthError do
  defexception [message: "Error trying to authenticate. Check Authorization header.",
                plug_status: 400]
end
