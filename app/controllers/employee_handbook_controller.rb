class EmployeeHandbookController < ApplicationController
  before_action :require_login
  before_action :clear_problematic_flash, only: [:index]

  PDF_DIRECTORY = Rails.root.join('public', 'pdfs')

  def index
    @handbook_documents = load_handbook_documents
  end

  def show
    Rails.logger.info "Show action called with params: #{params.inspect}"
    @document = find_document(params[:document])

    unless @document
      Rails.logger.info "Document not found: #{params[:document]}"
      redirect_to employee_handbook_path, alert: "Document not found"
      return
    end

    Rails.logger.info "Document found: #{@document[:name]}"
    @document_number = extract_document_number(params[:document])
  end

  private

  def load_handbook_documents
    return [] unless Dir.exist?(PDF_DIRECTORY)

    Dir.glob("#{PDF_DIRECTORY}/*.pdf").map do |file_path|
      filename = File.basename(file_path, '.pdf')

      # Handle new filename format: "01_introduction" -> name: "Introduction"
      match = filename.match(/^(\d+)_(.+)$/)

      if match
        {
          number: match[1].to_i,
          name: format_display_name(match[2]),
          filename: filename,
          path: file_path,
          url: "/pdfs/#{filename}.pdf"
        }
      else
        {
          number: 999,
          name: format_display_name(filename),
          filename: filename,
          path: file_path,
          url: "/pdfs/#{filename}.pdf"
        }
      end
    end.sort_by { |doc| doc[:number] }
  end

  def find_document(document_param)
    # Decode URL-encoded filename (e.g., "0.%20Company%20Policy" -> "0. Company Policy")
    filename = URI.decode_www_form_component(document_param)
    filename = File.basename(filename, '.pdf')
    full_path = File.join(PDF_DIRECTORY, "#{filename}.pdf")

    return nil unless File.exist?(full_path)

    load_handbook_documents.find { |doc| doc[:filename] == filename }
  end

  def extract_document_number(document_param)
    filename = File.basename(document_param, '.pdf')
    match = filename.match(/^(\d+)/)
    match ? match[1].to_i : 999
  end

  def clear_problematic_flash
    # Clear any lingering flash messages that might be showing
    flash.clear if flash[:alert]&.include?("Document not found")
  end

  def format_display_name(filename)
    # Convert underscores back to spaces and capitalize words
    # "company_policy_handbook_overview" -> "Company Policy Handbook Overview"
    filename.gsub(/_/, ' ').split.map(&:capitalize).join(' ')
  end
end