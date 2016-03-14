# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Chitoudl.Repo.insert!(%Chitoudl.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


Chitoudl.Repo.insert!(%Chitoudl.Chit{roomName: "general", user: "yur data", msg: "is mine now"})
Chitoudl.Repo.insert!(%Chitoudl.Chit{roomName: "general", user: "rube", msg: "whaaaat?"})
