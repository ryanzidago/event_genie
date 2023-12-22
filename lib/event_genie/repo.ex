defmodule EventGenie.Repo do
  use Ecto.Repo,
    otp_app: :event_genie,
    adapter: Ecto.Adapters.Postgres
end
