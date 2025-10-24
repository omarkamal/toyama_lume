class HolidaysController < ApplicationController
  before_action :require_login

  def index
    @holidays = load_holidays
    @current_year = Date.current.year
  end

  private

  def load_holidays
    yaml_path = Rails.root.join('config', 'holidays.yml')
    return [] unless File.exist?(yaml_path)

    yaml_data = YAML.load_file(yaml_path)
    all_holidays = []

    # Add company holidays
    if yaml_data['company_holidays']
      yaml_data['company_holidays'].each do |holiday|
        all_holidays << {
          name: holiday['name'],
          date: Date.parse(holiday['date']),
          company_only: true,
          type: 'company'
        }
      end
    end

    # Add national holidays
    if yaml_data['national_holidays_japan']
      yaml_data['national_holidays_japan'].each do |holiday|
        all_holidays << {
          name: holiday['name'],
          date: Date.parse(holiday['date']),
          company_only: false,
          type: 'national'
        }
      end
    end

    # Sort by date
    all_holidays.sort_by { |h| h[:date] }
  end
end