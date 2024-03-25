defmodule ReactorNotificationWorkerIssue.Accounts.Organization do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    # AshAdmin.Resource
    extensions: []

  @moduledoc """
  A resource for customer's tenant.
  """

  attributes do
    uuid_primary_key :id

    create_timestamp :created_at
    create_timestamp :updated_at
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    destroy :undo_create do
      argument :changeset, :struct do
        constraints instance_of: Ash.Changeset
      end
    end
  end

  postgres do
    table "organizations"
    repo ReactorNotificationWorkerIssue.Repo

    manage_tenant do
      template ["org_", :id]
    end
  end
end
