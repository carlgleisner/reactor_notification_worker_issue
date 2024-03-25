defmodule ReactorNotificationWorkerIssue.Accounts.Token do
  @moduledoc """
  An AshAuthentication token.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  token do
    api ReactorNotificationWorkerIssue.Accounts
  end

  multitenancy do
    strategy :context
  end

  postgres do
    table "tokens"
    repo ReactorNotificationWorkerIssue.Repo
  end
end
