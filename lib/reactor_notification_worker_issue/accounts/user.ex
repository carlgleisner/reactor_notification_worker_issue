defmodule ReactorNotificationWorkerIssue.Accounts.User do
  @moduledoc """
  A user in the application.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication],
    authorizers: [Ash.Policy.Authorizer]

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true, private?: true

    attribute :is_admin, :boolean, default: false
  end

  authentication do
    api ReactorNotificationWorkerIssue.Accounts

    strategies do
      password :password do
        identity_field :email
        register_action_accept [:is_admin]
      end
    end

    tokens do
      enabled? true
      token_resource ReactorNotificationWorkerIssue.Accounts.Token

      signing_secret fn _, _ ->
        {:ok, "not very secret does not matter"}
      end
    end
  end

  actions do
    defaults [:read, :update, :destroy]
  end

  identities do
    identity :unique_email, [:email]
  end

  # A safe default that only allows user data to be interacted with via AshAuthentication.
  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    policy always() do
      forbid_if always()
    end
  end

  multitenancy do
    strategy :context
  end

  postgres do
    table "users"
    repo ReactorNotificationWorkerIssue.Repo
  end
end
