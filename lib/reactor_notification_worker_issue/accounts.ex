defmodule ReactorNotificationWorkerIssue.Accounts do
  @moduledoc """
  Ash API for authentication.
  """
  use Ash.Api,
    extensions: [AshAdmin.Api]

  resources do
    resource ReactorNotificationWorkerIssue.Accounts.User
    resource ReactorNotificationWorkerIssue.Accounts.Token
    resource ReactorNotificationWorkerIssue.Accounts.Organization
  end

  # admin do
  #   show? true
  # end
end
