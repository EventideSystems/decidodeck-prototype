-- This SQL view aggregates data from various sources to create a unified view of people associated 
-- with an account, including stakeholders and users.
--
-- It combines information from stakeholders, account members, and users, providing a comprehensive overview of individuals
-- linked to an account, their roles, and basic details.

-- 1. Stakeholders
select
  id,
  account_id,
  type as linked_resource_type,
  id as linked_resource_id,
  coalesce(name, legal_name, first_name || ' ' || last_name) as name,
  status,
  email,
  influence_level,
  interest_level,
  'Stakeholder' as person_type,
  case type
  when 'Stakeholders::Individual' then 'Individual'
  when 'Stakeholders::Organization' then 'Organization'
  else 'Unknown'
  end as person_sub_type,
  created_at,
  updated_at
from stakeholders

union

-- 2. Account Members
select
  account_members.user_id,
  account_members.account_id,
  'User' as linked_resource_type,
  users.id as linked_resource_id,
  coalesce(
    nullif(users.name, ''), 
    initcap(translate(split_part(users.email, '@', 1), '0123456789.-_+', ''))
  ) as name,
  users.status,
  users.email,
  '' as influence_level,
  '' as interest_level,
  'Team Member' as person_type,
  'Collaborator' as person_sub_type,
  users.created_at,
  users.updated_at
from account_members
inner join accounts on account_members.account_id = accounts.id
inner join users on account_members.user_id = users.id

union

-- 3. Account Owners
select
  users.id,
  accounts.id as account_id,
  'User' as linked_resource_type,
  users.id as linked_resource_id,
  coalesce(
    nullif(users.name, ''), 
    initcap(translate(split_part(users.email, '@', 1), '0123456789.-_+', ''))
  ) as name,
  users.status,
  users.email,
  '' as influence_level,
  '' as interest_level,
  'Team Member' as person_type,
  'Account Owner' as person_sub_type,
  users.created_at,
  users.updated_at
from users
inner join accounts on users.id = accounts.owner_id
