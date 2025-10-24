# frozen_string_literal: true

require 'pagy'

module ApplicationHelper
  include Pagy::Frontend

  def flash_class(type)
    case type.to_sym
    when :notice then 'alert alert-info'
    when :alert then 'alert alert-warning'
    when :error then 'alert alert-danger'
    when :success then 'alert alert-success'
    else 'alert alert-secondary'
    end
  end

  def task_priority_badge(priority)
    classes = case priority
               when 'high' then 'bg-red-100 text-red-800'
               when 'medium' then 'bg-yellow-100 text-yellow-800'
               when 'low' then 'bg-green-100 text-green-800'
               else 'bg-gray-100 text-gray-800'
               end

    content_tag(:span, priority.titleize, class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{classes}")
  end

  def mood_emoji(mood)
    case mood
    when 'happy' then '😊'
    when 'neutral' then '😐'
    when 'sad' then '😔'
    else '😐'
    end
  end

  def task_status_badge(status)
    classes = case status
               when 'planned' then 'bg-gray-100 text-gray-800'
               when 'in_progress' then 'bg-blue-100 text-blue-800'
               when 'completed' then 'bg-green-100 text-green-800'
               when 'paused' then 'bg-yellow-100 text-yellow-800'
               else 'bg-gray-100 text-gray-800'
               end

    label = case status
            when 'planned' then 'Planned'
            when 'in_progress' then 'In Progress'
            when 'completed' then 'Completed'
            when 'paused' then 'Paused'
            else status.titleize
            end

    content_tag(:span, label, class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{classes}")
  end
end
