defmodule ReactorNotificationWorkerIssue.Repo do
  use AshPostgres.Repo, otp_app: :reactor_notification_worker_issue

  import Ecto.Query, only: [from: 2]

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end

  def all_tenants do
    all(from(row in "organizations", select: fragment("? || ?", "org_", row.id)))
  end
end
