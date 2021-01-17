defmodule LeodiDashboard.Repo do
  use Ecto.Repo,
    otp_app: :leodi_dashboard,
    adapter: Ecto.Adapters.Postgres
end
