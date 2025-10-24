# Lume – User Experience (Enhanced with Smart Tasks)

Goal: **Minimal taps, zero friction, intelligent suggestions, mobile-first**. All interactions work on a phone browser. No native app.

---

## 🧑‍💼 User Roles
- **Employee**: Punches in/out, selects tasks with smart suggestions, tracks time, requests leave, views policies/holidays, optionally logs mood.
- **Admin**: Same as employee + manages task templates, views team dashboard, approves leaves, analyzes task patterns.

---

## 🔄 Core User Journeys

### 1. **Morning: Punch In with Smart Tasks** ✅ IMPLEMENTED
- **Trigger**: Opens Lume on phone at work/client site.
- **Flow**:
  1. Home screen shows "Punch In" button (enabled only if location permission granted + within approved zone).
  2. Taps button → **Turbo modal opens with smart task suggestions**:
     - **Top suggestions**: 3-4 tasks based on frequency, time patterns, recent activity
     - **Quick add**: Tap any suggested task to add to today's plan (checkbox selection)
     - **Live search/autocomplete**: Type to find other tasks with real-time results
     - **Custom task**: "Add new task" option for unique work
     - **Location capture**: Automatic geolocation with retry functionality
     - **Mood selection**: 😊 😐 😞 (optional tap)
  3. Submits → **Geofencing validation** → Success message + auto-redirect to updated dashboard.
- **Error handling**: Clear messages for location denied, outside zones, or validation failures.

### 2. **Throughout Day: Task Management** ✅ IMPLEMENTED
- **Trigger**: User wants to update task progress or add new tasks.
- **Flow**:
  1. **Dashboard shows active session** with tasks and status indicators
  2. **Inline task controls**: "▶ Start Progress", "✓ Mark Complete" buttons
  3. **Add Task modal**: Quick task addition with smart suggestions during active session
  4. **Real-time updates** with Turbo Frames for instant feedback
  5. **Task status badges**: Visual indicators (Planned → In Progress → Completed)

### 3. **Evening: Punch Out with Task Completion** ✅ IMPLEMENTED
- **Trigger**: Opens Lume to end day.
- **Flow**:
  1. **"Punch Out" button appears** (only if already punched in today).
  2. **Modal opens with comprehensive task completion review**:
     - Session duration summary
     - Today's tasks listed with completion status checkboxes
     - Time allocation inputs for completed tasks (pre-filled suggestions)
     - **Additional task addition** for missed work
     - **Location capture** (mandatory for punch-out)
     - **Final mood selection** (optional)
  3. **Geofencing validation** → Day complete with success message and summary.

### 4. **Task Management (Personal & Templates)**
- **Path**: Nav → "Tasks" → "My Tasks" or "Task Templates"
- **Personal Tasks**:
  - Create/edit personal recurring tasks
  - Set estimated times and priorities
  - View task usage patterns and suggestions
- **Admin Template Management**:
  - Create/edit global task templates
  - Categorize by department, project, or type
  - Set default time estimates
  - View template usage analytics

### 5. **Request Leave**
- **Path**: Nav → "Leave" → "+ New Request"
- **Form**:
  - Date picker (start/end)
  - "Half-day?" toggle
  - Optional reason
- **Submit** → Confirmation + back to leave list (shows "Pending" status).

### 6. **View Policies or Holidays**
- **Path**: Bottom nav → "Policies" or "Calendar"
- **Policies**: List view → tap to read full HTML/PDF (no editing).
- **Calendar**: Month view with holidays marked (e.g., 🟢 Diwali). Team leaves shown as avatars below dates.

### 7. **Enhanced Admin Dashboard**
- **Path**: Nav → "Team" (admin-only)
- **Sections**:
  - **Attendance**: Today's punch status (✅ In / ⏳ Not yet / 🏡 WFH)
  - **Task Analytics**: Time spent by category, completion rates, trending tasks
  - **Leaves**: Pending requests with "Approve/Reject" buttons (Turbo update)
  - **Mood Trends**: Bar chart (aggregate only): "This week: 65% 😊"
  - **Work Logs**: Searchable list by name/date with task breakdowns
  - **Task Template Management**: Create/edit global task templates
  - **Work Zone Management**: Add/edit geofenced locations for punch validation

---

## 📱 Key Screens (Mobile-First, Task-Enhanced)

| Screen | Key Elements | Status |
|-------|--------------|--------|
| **Home** | Punch In/Out button, Smart task suggestions preview, Today's task progress, Quick stats | ✅ IMPLEMENTED |
| **Today's Dashboard** | Active tasks with status, quick actions, time tracking, progress indicators | ✅ IMPLEMENTED |
| **Task Library** | Searchable task list, categories, personal vs global templates, usage stats | ✅ IMPLEMENTED |
| **Leave List** | "+ Request" button, list of past/future leaves with status badges | 🔄 PENDING |
| **Policy List** | Search bar, policy titles with version/date | 🔄 PENDING |
| **Calendar** | Month grid, holiday labels, small team avatars for leaves | 🔄 PENDING |
| **Admin Dashboard** | Tabbed sections: Attendance, Task Analytics, Leaves, Mood, Templates, Work Zones | 🔄 PARTIAL |

---

## ⚡ Enhanced Interaction Principles ✅ IMPLEMENTED
- **Smart defaults**: Tasks suggested based on user patterns, time of day, project context
- **Minimal typing**: Primary interaction through tapping suggested tasks, autocomplete for search
- **Progressive enhancement**: Basic task selection works instantly, suggestions improve over time
- **No page reloads**: Turbo handles all navigation/form submissions with instant feedback
- **Location validation**: Requested and validated on punch screens with geofencing
- **Mood tracking**: One tap → instantly saved. No "Why?" follow-up.
- **Task controls**: Inline buttons for quick status changes, modal for task addition
- **Errors**: Inline, friendly, actionable (e.g., "Enable location access to punch in").
- **Empty states**: Friendly illustrations (e.g., "No tasks yet! Here are some suggestions...").

---

## 🎯 Smart Suggestion System UX ✅ IMPLEMENTED
- **Frequency-based**: Tasks done often appear higher in suggestions
- **Time-aware**: Morning vs afternoon task patterns
- **Project-context**: Related tasks suggested when working on specific projects
- **Team trends**: Anonymized popular tasks from colleagues (optional)
- **Learning**: System improves suggestions based on user selections and patterns
- **Live search**: Real-time task finding with autocomplete during task selection

---

## 🚫 What's Not in MVP UX
- Notifications or reminders
- Profile editing
- Asset check-in/out flows
- Gamification (badges, points)
- Real-time presence indicators
- Complex project management (Gantt charts, dependencies)

> Enhanced UX maintains the simplicity of the original design while adding intelligent task suggestions and tracking. Every screen maps to the enhanced database models including tasks, work_log_tasks, and work_zones for geofencing.