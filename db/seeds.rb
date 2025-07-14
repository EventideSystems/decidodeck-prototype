# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding development data..."

# Create example user
user = User.find_or_create_by!(email: "demo@decidodeck.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.confirmed_at = Time.current
  u.name = "Demo User"
  u.status = "active"
  puts "✅ Created demo user: #{u.email}"
end

# Create example account
account = Account.find_or_create_by!(name: "Demo Company") do |a|
  a.owner = user
  a.description = "A demonstration account for Decidodeck"
  a.status = "active"
  a.plan = "trial"
  a.plan_expires_at = 14.days.from_now
  a.max_users = 5
  a.max_workspaces = 3
  puts "✅ Created demo account: #{a.name}"
end

# Create example workspace
Workspace.find_or_create_by!(
  account: account,
  name: "Product Strategy 2025"
) do |w|
  w.description = "Strategic decisions for our product roadmap and feature prioritization"
  w.workspace_type = "project"
  w.status = "active"
  puts "✅ Created demo workspace: #{w.name}"
end

# Create additional sample workspaces
[ "Marketing Campaign Q1", "Engineering Architecture" ].each do |workspace_name|
  Workspace.find_or_create_by!(
    account: account,
    name: workspace_name
  ) do |w|
    w.description = "Sample workspace for #{workspace_name.downcase}"
    w.workspace_type = workspace_name.include?("Engineering") ? "department" : "initiative"
    w.status = "active"
    puts "✅ Created workspace: #{w.name}"
  end
end

# Create example stakeholders
stakeholders_data = [
  # People
  {
    type: "Stakeholders::Individual",
    first_name: "Sarah",
    last_name: "Johnson",
    job_title: "Product Manager",
    email: "sarah.johnson@example.com",
    stakeholder_type: "employee",
    influence_level: "high",
    interest_level: "critical"
  },
  {
    type: "Stakeholders::Individual",
    first_name: "Michael",
    last_name: "Chen",
    job_title: "CTO",
    email: "michael.chen@example.com",
    stakeholder_type: "employee",
    influence_level: "critical",
    interest_level: "high"
  },
  {
    type: "Stakeholders::Individual",
    first_name: "Emily",
    last_name: "Rodriguez",
    job_title: "Customer Success Manager",
    email: "emily.rodriguez@customer.com",
    stakeholder_type: "customer",
    influence_level: "medium",
    interest_level: "high"
  },
  # Organizations
  {
    type: "Stakeholders::Organization",
    legal_name: "TechCorp Solutions Inc.",
    name: "TechCorp",
    organization_type: "corporation",
    industry: "Technology",
    employee_count: 150,
    email: "partnerships@techcorp.com",
    stakeholder_type: "partner",
    influence_level: "high",
    interest_level: "medium"
  },
  {
    type: "Stakeholders::Organization",
    legal_name: "Global Ventures LLC",
    name: "Global Ventures",
    organization_type: "llc",
    industry: "Investment",
    employee_count: 25,
    email: "deals@globalventures.com",
    stakeholder_type: "investor",
    influence_level: "critical",
    interest_level: "medium"
  }
]

stakeholders_data.each do |stakeholder_attrs|
  stakeholder_type = stakeholder_attrs.delete(:type)

  stakeholder_type.constantize.find_or_create_by!(
    account: account,
    email: stakeholder_attrs[:email]
  ) do |s|
    stakeholder_attrs.each do |key, value|
      s.send("#{key}=", value)
    end
    puts "✅ Created #{stakeholder_type.demodulize.downcase}: #{stakeholder_attrs[:name] || "#{stakeholder_attrs[:first_name]} #{stakeholder_attrs[:last_name]}" || stakeholder_attrs[:legal_name]}"
  end
end

# Create example artifact content infos
artifact_content_infos_data = [
  {
    owner: account,
    markdown: "# Project Overview\n\nThis document outlines the strategic direction and key objectives for our product roadmap in 2025.\n\n## Key Goals\n- Improve user engagement by 40%\n- Reduce time-to-value for new users\n- Expand market reach"
  },
  {
    owner: account,
    markdown: "# Technical Architecture\n\n## System Components\n\n### Frontend\n- React with TypeScript\n- Tailwind CSS for styling\n- Vite for build tooling\n\n### Backend\n- Ruby on Rails API\n- PostgreSQL database\n- Redis for caching"
  },
  {
    owner: account,
    markdown: "# User Research Findings\n\n## Executive Summary\n\nOur recent user research revealed several key insights about user behavior and preferences.\n\n## Key Findings\n1. Users prefer simplified navigation\n2. Mobile experience needs improvement\n3. Onboarding process is too complex"
  },
  {
    owner: account,
    markdown: "# Marketing Strategy Q1\n\n## Campaign Objectives\n- Increase brand awareness\n- Generate qualified leads\n- Drive product adoption\n\n## Target Channels\n- Social media campaigns\n- Content marketing\n- Partner collaborations"
  },
  {
    owner: account,
    markdown: "# Decision Framework\n\n## Evaluation Criteria\n\n### Technical Feasibility\n- Implementation complexity\n- Resource requirements\n- Timeline constraints\n\n### Business Impact\n- Revenue potential\n- Market opportunity\n- Competitive advantage"
  }
]

artifact_content_infos = []
artifact_content_infos_data.each_with_index do |info_attrs, index|
  info = ArtifactContent::Info.find_or_create_by!(
    owner: info_attrs[:owner],
    markdown: info_attrs[:markdown]
  )
  artifact_content_infos << info
  puts "✅ Created artifact content info #{index + 1}: #{info.display_name}"
end

# Create example artifacts
workspaces = account.workspaces.to_a
artifacts_data = [
  {
    workspace: workspaces[0],
    content: artifact_content_infos[0],
    tags: [ "strategy", "product", "roadmap" ]
  },
  {
    workspace: workspaces[0],
    content: artifact_content_infos[4],
    tags: [ "decision", "framework", "process" ]
  },
  {
    workspace: workspaces[1],
    content: artifact_content_infos[3],
    tags: [ "marketing", "campaign", "q1" ]
  },
  {
    workspace: workspaces[2],
    content: artifact_content_infos[1],
    tags: [ "technical", "architecture", "engineering" ]
  },
  {
    workspace: workspaces[0],
    content: artifact_content_infos[2],
    tags: [ "research", "users", "insights" ]
  }
]

artifacts_data.each do |artifact_attrs|
  Artifact.find_or_create_by!(
    workspace: artifact_attrs[:workspace],
    content: artifact_attrs[:content]
  ) do |a|
    a.tags = artifact_attrs[:tags]
    puts "✅ Created artifact with tags: #{a.tags.join(', ')}"
  end
end

puts "🎉 Seeding completed!"
puts ""
puts "Demo credentials:"
puts "  Email: demo@decidodeck.com"
puts "  Password: password123"
puts ""
puts "Created:"
puts "  - 1 demo user"
puts "  - 1 demo account (#{account.name})"
puts "  - #{account.workspaces.count} sample workspaces"
puts "  - #{account.workspaces.map(&:artifacts).flatten.count} artifacts"
puts "  - #{artifact_content_infos.count} artifact content infos"
