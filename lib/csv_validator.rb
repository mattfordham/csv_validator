require 'active_model'
require 'active_model/validations'
require 'csv'
require 'mail'

class CsvValidator < ActiveModel::EachValidator
  @@default_options = {}
  
  def self.default_options
    @@default_options
  end
  
  def validate_each(record, attribute, value)
    options = @@default_options.merge(self.options)
    
    begin
      csv = CSV.read(value)
    rescue CSV::MalformedCSVError
      record.errors.add(attribute, options[:message] || "is not a valid CSV file")
      return
    end
    
    if options[:columns]
      unless csv[0].length == options[:columns]
        record.errors.add(attribute, options[:message] || "should have #{options[:columns]} columns")
      end
    end

    if options[:max_columns]
      if csv[0].length > options[:max_columns]
        record.errors.add(attribute, options[:message] || "should have no more than #{options[:max_columns]} columns")
      end
    end

    if options[:min_columns]
      if csv[0].length < options[:min_columns]
        record.errors.add(attribute, options[:message] || "should have at least #{options[:min_columns]} columns")
      end
    end

    if options[:rows]
      unless csv.length == options[:rows]
        record.errors.add(attribute, options[:message] || "should have #{options[:rows]} rows")
      end
    end

    if options[:min_rows]
      if csv.length < options[:min_rows]
        record.errors.add(attribute, options[:message] || "should have at least #{options[:min_rows]} rows")
      end
    end

    if options[:max_rows]
      if csv.length > options[:max_rows]
        record.errors.add(attribute, options[:message] || "should have no more than #{options[:max_rows]} rows")
      end
    end

    if options[:email]
      emails = column_to_array(csv, options[:email])
      invalid_emails = []
      emails.each do |email|
        begin
          address = Mail::Address.new email
          valid = address.address == email && address.domain
          tree = address.__send__(:tree)        
          valid &&= (tree.domain.dot_atom_text.elements.size > 1)
        rescue
          valid = false
        end
        unless valid
          invalid_emails << email
        end
      end
      
      if invalid_emails.length > 0
        record.errors.add(attribute, options[:message] || "contains invalid emails (#{invalid_emails.join(', ')})")
      end
    end

    if options[:numericality]
      numbers = column_to_array(csv, options[:numericality])
      numbers.each do |number|
        unless is_numeric?(number)
          record.errors.add(attribute, options[:message] || "contains non-numeric content in column #{options[:numericality]}")
          return
        end
      end
    end
    
  end
  
  private
  
  def column_to_array(csv, column_index)
    column_contents = []
    csv.each do |column|    
      column_contents << column[column_index].strip
    end
    column_contents
  end
  
  def is_numeric?(string)
    Float(string)
    true 
  rescue 
    false
  end
  
  
end
