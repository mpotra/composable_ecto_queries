defmodule AccessTokens do
  @moduledoc """
  A module that provides basic functionality to retrieve
  an Access Token via its ID.
  """
  import Ecto.Query

  alias AccessToken
  alias Issuer
  alias Audience

  @doc """
  Retrieve an AccessToken schema struct, given it's ID.

  See query_by_id/2 for further details on how records are matched.

  """
  @spec get_by_id(access_token_id :: pos_integer()) :: AccessToken.t() | nil
  def get_by_id(access_token_id) do
    query()
    |> query_by_id(access_token_id)
    |> Repo.one()
  end

  @doc """
  Builds the base query for an AccessToken
  """
  @spec query() :: Ecto.Query.t()
  def query() do
    from(t in AccessToken, as: :token)
  end

  @doc """
  Given an AccessToken query, it will match records by the given ID
  and also ensure that the record has not been revoked, nor expired.
  Futhermore, it will validate the issuer and audience associations to be valid.

  Records that have been revoked, or where the audience has been disabled
  temporarily or permanently, will not be matched.
  """
  @spec query_by_id(query :: Ecto.Queryable.t(), access_token_id :: pos_integer()) ::
          Ecto.Queryable.t()
  def query_by_id(queryable, id) do
    queryable
    |> where([..., t], t.id == ^id)
    |> not_revoked()
    |> not_expired()
    |> query_with_issuer()
    |> query_with_audience()
  end

  @doc """
  Given a query, append join statements on the Issuers table,
  and validate that the issuer has not been disabled temporarily or permanently.
  """
  @spec query_with_issuer(query :: Ecto.Queryable.t()) :: Ecto.Queryable.t()
  def query_with_issuer(queryable) do
    queryable
    |> join(:inner, [token: t], i in Issuer, on: t.issuer_id == i.id)
    |> not_deleted()
    |> not_disabled()
  end

  @doc """
  Given a query, append join statements on the Audience table,
  and validate that the audience has not been disabled temporarily or permanently.
  """
  @spec query_with_audience(query :: Ecto.Queryable.t()) :: Ecto.Queryable.t()
  def query_with_audience(queryable) do
    queryable
    |> join(:inner, [token: t], a in Audience, on: t.audience_id == a.id)
    |> not_deleted()
    |> not_disabled()
  end

  @doc """
  Given a query, append a where clause to only select access tokens
  that have not yet expired, by comparing CURRENT_TIMESTAMP and token.created_at + token.expires_in
  """
  @spec not_expired(query :: Ecto.Queryable.t()) ::
          Ecto.Queryable.t()
  def not_expired(queryable) do
    queryable
    |> where(
      [..., t],
      fragment("current_timestamp <= ? + (interval '1' second * ?)", t.created_at, t.expires_in)
    )
  end

  @doc """
  Given a query, append a where clause to only select the records
  that have the `revoked_at` field set to NULL.
  Otherwise the record is considered to have been revoked and not valid.
  """
  @spec not_revoked(query :: Ecto.Queryable.t()) ::
          Ecto.Queryable.t()
  def not_revoked(queryable) do
    queryable
    |> where([..., t], is_nil(t.revoked_at))
  end

  @doc """
  Given a query, append a where clause to only select the records
  that have the `enabled` field set to `true`.
  Otherwise the record is considered to have been temporarily disabled and not valid.
  """
  @spec not_disabled(queryable :: Ecto.Queryable.t()) :: Ecto.Queryable.t()
  def not_disabled(queryable) do
    queryable
    |> where([..., r], r.enabled == true)
  end

  @doc """
  Given a query, append a where clause to only select the records
  that have the `deleted_at` field set to NULL.
  Otherwise the record is considered to have been permanently disabled and not valid.
  """
  @spec not_deleted(queryable :: Ecto.Queryable.t()) :: Ecto.Queryable.t()
  def not_deleted(queryable) do
    queryable
    |> where([..., r], is_nil(r.deleted_at))
  end
end
