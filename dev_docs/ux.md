# Lume – User Experience (Enhanced with Smart Tasks)

Goal: **Minimal taps, zero friction, intelligent suggestions, mobile-first**. All interactions work on a phone browser. No native app.

---

## 🧑‍💼 User Roles
- **Employee**: Punches in/out, selects tasks with smart suggestions, tracks time, requests leave, views policies/holidays, optionally logs mood.
- **Admin**: Same as employee + manages task templates, views team dashboard, approves leaves, analyzes task patterns.

---

## 🔄 Core User Journeys

### 1. **Morning: Punch In with Smart Tasks**
- **Trigger**: Opens Lume on phone at work/client site.
- **Flow**:
  1. Home screen shows "Punch In" button (enabled only if location permission granted + within approved zone).
  2. Taps button → Turbo modal opens with **smart task suggestions**:
     - **Top suggestions**: 3-4 tasks based on frequency, time patterns, recent activity
     - **Quick add**: Tap any suggested task to add to today's plan
     - **Search/autocomplete**: Type to find other tasks (personal or global templates)
     - **Custom task**: "Add new task" option for unique work
     - Mood row: 😊 😐 😞 (optional tap)
  3. Submits → Success message + auto-redirect to **Today's Task Dashboard**.
- **Error**: If location invalid → clear message: "You're outside approved work zones."

### 2. **Throughout Day: Task Management**
- **Trigger**: User wants to update task progress or add new tasks.
- **Flow**:
  1. Today's Summary shows active tasks with status indicators
  2. Tap any task → Quick actions: "Start Progress", "Mark Complete", "Add Time"
  3. Swipe gestures for quick status changes (mobile-first)
  4. Real-time updates with Turbo Streams

### 3. **Evening: Punch Out with Task Completion**
- **Trigger**: Opens Lume to end day.
- **Flow**:
  1. "Punch Out" button appears (only if already punched in today).
  2. Modal opens with **task completion review**:
     - Today's tasks listed with completion status
     - Quick toggle for incomplete tasks
     - Auto-suggested time allocations based on patterns
     - Optional reflection notes (minimal, task-focused)
     - Mood row (optional)
  3. Submits → Day complete. Shows task completion summary and weekly insights.

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

---

## 📱 Key Screens (Mobile-First, Task-Enhanced)

| Screen | Key Elements |
|-------|--------------|
| **Home** | Punch In/Out button, Smart task suggestions preview, Today's task progress |
| **Today's Dashboard** | Active tasks with status, quick actions, time tracking, progress indicators |
| **Task Library** | Searchable task list, categories, personal vs global templates, usage stats |
| **Leave List** | "+ Request" button, list of past/future leaves with status badges |
| **Policy List** | Search bar, policy titles with version/date |
| **Calendar** | Month grid, holiday labels, small team avatars for leaves |
| **Admin Dashboard** | Tabbed sections: Attendance, Task Analytics, Leaves, Mood, Templates |

---

## ⚡ Enhanced Interaction Principles
- **Smart defaults**: Tasks suggested based on user patterns, time of day, project context
- **Minimal typing**: Primary interaction through tapping suggested tasks, autocomplete for search
- **Progressive enhancement**: Basic task selection works instantly, suggestions improve over time
- **No page reloads**: Turbo handles all navigation/form submissions with instant feedback
- **Location**: Requested only on punch screens (not on app load)
- **Mood**: One tap → instantly saved. No "Why?" follow-up.
- **Task gestures**: Swipe to complete, long-press for options, drag to reorder
- **Errors**: Inline, friendly, actionable (e.g., "Add 5 more characters").
- **Empty states**: Friendly illustrations (e.g., "No tasks yet! Here are some suggestions...").

---

## 🎯 Smart Suggestion System UX
- **Frequency-based**: Tasks done often appear higher in suggestions
- **Time-aware**: Morning vs afternoon task patterns
- **Project-context**: Related tasks suggested when working on specific projects
- **Team trends**: Anonymized popular tasks from colleagues (optional)
- **Learning**: System improves suggestions based on user selections and patterns

---

## 🚫 What's Not in MVP UX
- Notifications or reminders
- Profile editing
- Asset check-in/out flows
- Gamification (badges, points)
- Real-time presence indicators
- Complex project management (Gantt charts, dependencies)

> Enhanced UX maintains the simplicity of the original design while adding intelligent task suggestions and tracking. Every screen maps to the enhanced database models including tasks and work_log_tasks.