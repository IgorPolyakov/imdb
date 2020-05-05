defmodule SerialKiller.Searcher do
  alias SerialKiller.DB

  # TODO: make it configurable via query string
  @limit 100

  def search(words) do
    DB.query!(
      "SELECT *
       FROM shows
       WHERE title_to_tsvector(title) @@ plainto_tsquery('simple', unaccent($1))
       ORDER BY num_votes
       LIMIT #{@limit}",
      [words]
    )
  end
end
