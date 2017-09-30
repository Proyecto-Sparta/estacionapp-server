defmodule EstacionappServer.Error do
  defmodule Unauthorized do
    @moduledoc """
    Exception raised on unauthorized requests.
    status 401 = :unauthorized
    """

    defexception message: "Unauthorized",
                 plug_status: 401

    def exception(opts) do    
      %Unauthorized{message: Keyword.fetch!(opts, :message)}    
    end
  end

   defmodule BadRequest do
    @moduledoc """
    Exception raised on incorrect requests.
    status 400 = :bad_request
    """

    defexception message: "Bad request",
                 plug_status: 400

    def exception(opts) do    
      %BadRequest{message: Keyword.fetch!(opts, :message)}    
    end
  end

  defmodule NotFound do
    @moduledoc """
    Exception raised on not found resources.
    status 404 = :not_found
    """

    defexception message: "Not found",
                 plug_status: 404

    def exception(_opts) do    
      %NotFound{}    
    end
  end
end
