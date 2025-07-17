class CreateInterestSets < ActiveRecord::Migration[8.0]
  def change
    create_view :interest_sets
  end
end

# CREATE AGGREGATE tsvector_agg(tsvector) (
#    STYPE = pg_catalog.tsvector,
#    SFUNC = pg_catalog.tsvector_concat,
#    INITCOND = ''
# );
