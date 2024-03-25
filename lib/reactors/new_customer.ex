defmodule ReactorNotificationWorkerIssue.Reactors.NewCustomer do
  use Ash.Reactor

  @moduledoc """
  Orchestrate the creation of resources for new customers.

  This reactor will create a new tenant `Organization` along with an initial `User`.
  """

  ash do
    default_api ReactorNotificationWorkerIssue.Accounts
  end

  input :email
  input :password

  create :create_organization, ReactorNotificationWorkerIssue.Accounts.Organization, :create do
    description "Create organization, i.e. the tenant"

    undo(:always)
    undo_action(:undo_create)
  end

  step :get_tenant do
    argument :organization_id, result(:create_organization, :id)

    run fn %{organization_id: organization_id}, _ ->
      {:ok, "org_#{organization_id}"}
    end
  end

  create :create_user, ReactorNotificationWorkerIssue.Accounts.User, :register_with_password do
    description "Create an admin user in the newly created tenant"

    inputs(%{
      email: input(:email),
      password: input(:password),
      password_confirmation: input(:password),
      is_admin: value(true)
    })

    tenant result(:get_tenant)
  end

  return(:create_organization)
end
