select
  id,
  name,
  description,
  status,
  email,
  phone,
  address,
  website,
  first_name,
  last_name,
  job_title,
  birth_date,
  legal_name,
  organization_type,
  industry,
  employee_count,
  founded_date,
  stakeholder_type,
  influence_level,
  interest_level,
  priority_score,
  account_id,
  case type
  when 'Stakeholders::Individual' then 'Individual'
  when 'Stakeholders::Organization' then 'Organization'
  else 'Unknown'
  end as person_type
from stakeholders