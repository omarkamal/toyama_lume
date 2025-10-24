# Seed data for Lume app

# Create admin user
admin_user = User.find_or_create_by!(email: "admin@toyama.com") do |user|
  user.name = "Admin User"
  user.role = :admin
  user.password = "password123"
  user.password_confirmation = "password123"
end

# Create employee users
employee_users = [
  { name: "John Doe", email: "john@toyama.com" },
  { name: "Jane Smith", email: "jane@toyama.com" },
  { name: "Mike Johnson", email: "mike@toyama.com" }
]

employees = employee_users.map do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |user|
    user.name = user_data[:name]
    user.role = :employee
    user.password = "password123"
    user.password_confirmation = "password123"
  end
end

# Create global task templates
global_tasks = [
  { title: "Morning standup meeting", category: "Meetings", priority: "high", description: "Daily team standup meeting" },
  { title: "Email review", category: "Communication", priority: "medium", description: "Review and respond to emails" },
  { title: "Code review", category: "Development", priority: "high", description: "Review team pull requests" },
  { title: "Documentation", category: "Development", priority: "low", description: "Update project documentation" },
  { title: "Bug fixes", category: "Development", priority: "high", description: "Fix reported bugs" },
  { title: "Feature development", category: "Development", priority: "high", description: "Work on new features" },
  { title: "Team planning", category: "Meetings", priority: "medium", description: "Sprint planning and retrospectives" },
  { title: "Client communication", category: "Communication", priority: "high", description: "Communicate with clients about project progress" }
]

global_tasks.each do |task_data|
  Task.find_or_create_by!(title: task_data[:title], user: admin_user) do |task|
    task.description = task_data[:description]
    task.category = task_data[:category]
    task.priority = task_data[:priority]
    task.is_global = true
    task.usage_count = rand(5..20)
  end
end

# Create personal tasks for each employee
employees.each do |employee|
  personal_tasks = [
    { title: "Personal development", category: "Learning", priority: "low", description: "Learning new technologies" },
    { title: "Project research", category: "Research", priority: "medium", description: "Research for current project" }
  ]

  personal_tasks.each do |task_data|
    Task.find_or_create_by!(title: "#{task_data[:title]} - #{employee.name.split.first}", user: employee) do |task|
      task.description = task_data[:description]
      task.category = task_data[:category]
      task.priority = task_data[:priority]
      task.is_global = false
      task.usage_count = rand(1..5)
    end
  end
end

# Create work zones (geofenced areas where employees can punch in/out)
work_zones = [
  {
    name: "Main Office - Tokyo",
    latitude: 35.6762,
    longitude: 139.6503,
    radius: 200, # 200 meters
    description: "Main Toyama office in Tokyo",
    active: true
  },
  {
    name: "Remote Office - Osaka",
    latitude: 34.6937,
    longitude: 135.5023,
    radius: 150,
    description: "Osaka branch office",
    active: true
  },
  {
    name: "Client Site - Shinjuku",
    latitude: 35.6895,
    longitude: 139.6917,
    radius: 100,
    description: "Client meeting location",
    active: true
  }
]

work_zones.each do |zone_data|
  WorkZone.find_or_create_by!(name: zone_data[:name]) do |zone|
    zone.latitude = zone_data[:latitude]
    zone.longitude = zone_data[:longitude]
    zone.radius = zone_data[:radius]
    zone.description = zone_data[:description]
    zone.active = zone_data[:active]
  end
end

puts "Created #{User.count} users"
puts "Created #{Task.count} tasks"
puts "Created #{WorkZone.count} work zones"
puts "Seed data completed successfully!"
