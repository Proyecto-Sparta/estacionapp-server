defmodule EstacionappServer.NotificationChannelTest do
  use EstacionappServer.ChannelCase

  alias EstacionappServer.NotificationChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(NotificationChannel, "garage:medrano")

    {:ok, socket: socket}
  end

  test "joining sends a request event" do
    assert_broadcast "request", %{}
  end

  test "request broadcasts to that channel", %{socket: socket} do
    push socket, "request", %{}
    assert_broadcast "request", %{}
  end

  test "accepting some user broadcasts to that channel", %{socket: socket} do
    push socket, "accept:joseValim", %{}
    assert_broadcast "accept:joseValim", %{}
  end

  test "denying some user broadcasts to that channel", %{socket: socket} do
    push socket, "deny:joseValim", %{}
    assert_broadcast "deny:joseValim", %{}
  end
end
