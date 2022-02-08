defmodule AccessTokensTest do
  use ExUnit.Case
  doctest AccessTokens

  test "query/1 builds expected SQL query" do
    assert to_sql(AccessTokens.query()) ==
             {"SELECT a0.\"id\", a0.\"issuer_id\", a0.\"audience_id\", a0.\"expires_in\", a0.\"created_at\", a0.\"revoked_at\" FROM \"access_tokens\" AS a0",
              []}
  end

  test "query_by_id/1 builds expected SQL query" do
    assert sql = to_sql(AccessTokens.query_by_id(AccessTokens.query(), 1))

    assert sql ==
             {"SELECT a0.\"id\", a0.\"issuer_id\", a0.\"audience_id\", a0.\"expires_in\", a0.\"created_at\", a0.\"revoked_at\" FROM \"access_tokens\" AS a0 INNER JOIN \"issuers\" AS i1 ON a0.\"issuer_id\" = i1.\"id\" INNER JOIN \"audience\" AS a2 ON a0.\"audience_id\" = a2.\"id\" WHERE (a0.\"id\" = $1) AND (a0.\"revoked_at\" IS NULL) AND (current_timestamp <= a0.\"created_at\" + (interval '1' second * a0.\"expires_in\")) AND (i1.\"deleted_at\" IS NULL) AND (i1.\"enabled\" = TRUE) AND (a2.\"deleted_at\" IS NULL) AND (a2.\"enabled\" = TRUE)",
              [1]}
  end

  @spec to_sql(query :: Ecto.Queryable.t()) :: binary()
  defp to_sql(queryable) do
    Ecto.Adapters.SQL.to_sql(:all, Repo, queryable)
  end
end
