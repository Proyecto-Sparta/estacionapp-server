defmodule EstacionappServer.NotificationChannel do
  use EstacionappServer.Web, :channel

  def join("garage:" <> _garage, payload, socket) do
    send self(), {:request, payload}
    {:ok, socket}
  end

  def handle_info({:request, payload}, socket) do
    broadcast! socket, "request", payload    
    {:noreply, socket}
  end

  def handle_in("accept:" <> driver_name, payload, socket) do
    broadcast! socket, "accept:" <> driver_name, payload
    {:noreply, socket}
  end
  
  def handle_in("deny:" <> driver_name, payload, socket) do
    broadcast! socket, "deny:" <> driver_name, payload
    {:noreply, socket}
  end
end
