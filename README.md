# Reproduction of issue: Ash Reactor Notifications

This repo is used to show a potential issue in the Ash framework.

## Background

The potential issue presents itself when running a reactor created using the Ash framework's Reactor extension. The steps are run successfully, but the reactor returns an `{:error, error}` tuple where it seems like it could not find the Ash notification agent.

However, upon running the reactor again in the same `iex` session, the correct and expected `{:ok, organization}` tuple is returned.

First run in a new `iex` session:

```elixir
{:error,
 [
   %KeyError{
     key: :__ash_notification_agent__,
     term: %{
       private: %{
         composed_reactors: MapSet.new([ReactorNotificationWorkerIssue.Reactors.NewCustomer]),
         inputs: %{password: "asdfasdf", email: "admin@example.com"}
       },
       __ash_hooked__: true,
       concurrency_key: #Reference<0.378456948.1978925057.168268>,
       __reactor__: %{
         id: ReactorNotificationWorkerIssue.Reactors.NewCustomer,
         initial_state: :pending,
         inputs: [:password, :email],
         middleware: [Ash.Reactor.Tracer, Ash.Reactor.Notifications],
         step_count: 4
       },
       current_step: %Reactor.Step{
         arguments: [
           %Reactor.Argument{
             name: :input,
             source: %Reactor.Template.Value{value: %{}},
             transform: nil
           }
         ],
         async?: true,
         context: %{},
         impl: {Ash.Reactor.CreateStep,
          [
            resource: ReactorNotificationWorkerIssue.Accounts.Organization,
            action: :create,
            api: ReactorNotificationWorkerIssue.Accounts,
            undo: :always,
            undo_action: :undo_create,
            authorize?: nil,
            upsert_identity: nil,
            upsert?: false
          ]},
         name: :create_organization,
         max_retries: 100,
         ref: :create_organization,
         transform: nil
       },
       current_try: 0,
       retries_remaining: 100
     },
     message: nil
   }
 ]}
```

Second run, and any subsequent runs, with the same inputs in the same `iex` session work just fine.

```elixir
{:ok,
 #ReactorNotificationWorkerIssue.Accounts.Organization<
   __meta__: #Ecto.Schema.Metadata<:loaded, "organizations">,
   id: "c8d04147-feea-4034-9975-2ad7b33060b3",
   created_at: ~U[2024-03-25 08:38:52.522945Z],
   updated_at: ~U[2024-03-25 08:38:52.522945Z],
   aggregates: %{},
   calculations: %{},
   ...
 >}
```

Any test to the effect predictably fails.

This appears in the context of a multitenancy application using the context strategy.

## Steps to reproduce

### Setup

```sh
mix deps.get
mix compile
mix ash_postgres.create
mix ash_postgres.migrate
mix ash_postgres.migrate --tenants

iex -S mix phx.server
```

### Run the reactor

```elixir
inputs = %{
	email: "admin@example.com",
	password: "asdfasdf"
}

Reactor.run(ReactorNotificationWorkerIssue.Reactors.NewCustomer, inputs)
```

Re-run the reactor.

```elixir
Reactor.run(ReactorNotificationWorkerIssue.Reactors.NewCustomer, inputs)
```
