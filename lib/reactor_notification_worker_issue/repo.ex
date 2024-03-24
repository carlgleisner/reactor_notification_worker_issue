defmodule ReactorNotificationWorkerIssue.Repo do
  use Ecto.Repo,
    otp_app: :reactor_notification_worker_issue,
    adapter: Ecto.Adapters.Postgres
end
