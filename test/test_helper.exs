ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Chitoudl.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Chitoudl.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Chitoudl.Repo)

