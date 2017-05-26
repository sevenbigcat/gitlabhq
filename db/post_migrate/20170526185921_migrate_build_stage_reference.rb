class MigrateBuildStageReference < ActiveRecord::Migration
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def up
    disable_statement_timeout

    stage_id = Arel.sql('(SELECT id FROM ci_stages ' \
                         'WHERE ci_stages.pipeline_id = ci_builds.commit_id ' \
                         'AND ci_stages.name = ci_builds.stage)')

    update_column_in_batches(:ci_builds, :stage_id, stage_id)
  end

  def down
    disable_statement_timeout

    update_column_in_batches(:ci_builds, :stage_id, nil)
  end
end
