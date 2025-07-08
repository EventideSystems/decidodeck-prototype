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
