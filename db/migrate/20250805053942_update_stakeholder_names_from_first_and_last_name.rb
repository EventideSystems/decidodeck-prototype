class UpdateStakeholderNamesFromFirstAndLastName < ActiveRecord::Migration[8.0]
  def up
    # Update Individual stakeholders where first_name and/or last_name exist
    # Use PostgreSQL syntax for concatenation
    execute <<-SQL
      UPDATE stakeholders#{' '}
      SET name = TRIM(COALESCE(first_name, '') || ' ' || COALESCE(last_name, ''))
      WHERE type = 'Stakeholders::Individual'#{' '}
        AND (first_name IS NOT NULL OR last_name IS NOT NULL)
        AND TRIM(COALESCE(first_name, '') || ' ' || COALESCE(last_name, '')) != ''
    SQL
  end

  def down
    # No rollback needed - we're just updating data to be consistent
    # The original name values would be lost, so we can't roll back
  end
end
