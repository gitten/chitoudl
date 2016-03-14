defmodule Chitoudl.Chit do
  use Chitoudl.Web, :model

  schema "chits" do
    field :roomName, :string
    field :user, :string
    field :msg, :string

    timestamps
  end

  @required_fields ~w(roomName user msg)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end



defimpl Poison.Encoder, for: Chitoudl.Chit do
  def encode(model, opts) do
    %{ 
      id: model.id,
      roomName: model.roomName,
      user: model.user,
      msg: model.msg
      
     }
    |> Poison.Encoder.encode(opts)
  end
end
