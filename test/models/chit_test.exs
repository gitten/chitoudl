defmodule Chitoudl.ChitTest do
  use Chitoudl.ModelCase

  alias Chitoudl.Chit

  @valid_attrs %{msg: "some content", roomName: "some content", user: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Chit.changeset(%Chit{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Chit.changeset(%Chit{}, @invalid_attrs)
    refute changeset.valid?
  end
end
