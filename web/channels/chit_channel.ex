defmodule Chitoudl.ChitChannel do
  use Chitoudl.Web, :channel

  
  def join("chits:general", payload, socket) do
    if authorized?(payload) do
      send self(), :after_join
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chits:lobby).
  def handle_in("from:elm", payload, socket) do
    broadcast socket, "from:elm", payload

    #impliment with protocol instead?
    data = for {key, value} <- payload, into: %{}, do: {String.to_atom( key), value}
    

    Repo.insert! struct( Chitoudl.Chit, data )
    
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
