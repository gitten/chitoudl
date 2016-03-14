defmodule Chitoudl.Repo.Migrations.CreateChit do
  use Ecto.Migration

  def change do
    create table(:chits) do
      add :roomName, :string
      add :user, :string
      add :msg, :string

      timestamps
    end

  end
end
