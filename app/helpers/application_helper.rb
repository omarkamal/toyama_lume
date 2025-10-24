# frozen_string_literal: true

require "pagy"

module ApplicationHelper
  include Pagy::Frontend

  def flash_class(type)
    case type.to_sym
    when :notice then "bg-teal/10 border border-teal/30 text-navy"
    when :alert then "bg-yellow-50 border border-yellow-200 text-yellow-900"
    when :error then "bg-red-50 border border-red-200 text-red-900"
    when :success then "bg-lime/10 border border-lime/30 text-navy"
    else "bg-carbon-light border border-cloudy text-carbon-heavy"
    end
  end

  def task_priority_badge(priority)
    classes = case priority
    when "high" then "bg-red-100 text-red-800"
    when "medium" then "bg-yellow-100 text-yellow-800"
    when "low" then "bg-lime/10 text-lime"
    else "bg-cloudy text-carbon-heavy"
    end

    content_tag(:span, priority.titleize,
                class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-body font-light #{classes}")
  end

  def mood_emoji(mood)
    case mood
    when "happy" then "😊"
    when "neutral" then "😐"
    when "sad" then "😔"
    else "😐"
    end
  end

  def task_status_badge(status)
    classes = case status
    when "planned" then "bg-cloudy text-carbon-heavy"
    when "in_progress" then "bg-teal/10 text-teal"
    when "completed" then "bg-lime/10 text-lime"
    when "paused" then "bg-yellow-100 text-yellow-800"
    else "bg-cloudy text-carbon-heavy"
    end

    label = case status
    when "planned" then "Planned"
    when "in_progress" then "In Progress"
    when "completed" then "Completed"
    when "paused" then "Paused"
    else status.titleize
    end

    content_tag(:span, label,
                class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-body font-light #{classes}")
  end
end
