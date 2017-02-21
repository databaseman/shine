#
#SELECT *
#FROM customers
#WHERE
#  lower(first_name) LIKE 'bob%' OR
#  lower(last_name) LIKE 'bob%' OR
#  lower(email) = 'bob@example.com'
#ORDER BY
#  email = 'bob@example.com' DESC,
#  last_name ASC
#
#Customer.where
# ("lower(first_name) LIKE :first_name OR " +     <== @where_clause
#		"lower(last_name) LIKE :last_name OR " +      <== @where_clause
#		"lower(email) = :email", 		                  <== @where_clause
#		{
#		  first_name: "bob%",                         <== @where_args
#		  last_name: "bob%",                          <== @where_args
#		  email: "bob@example.com"                    <== @where_args 
#		}
#	).order("email = 'bob@example.com' desc, last_name asc")
#

class CustomerSearchTerm
  attr_reader :where_clause, :where_args, :order
  
  def initialize(search_term)
    search_term = search_term.downcase
    @where_clause = ""
    @where_args = {}
    if search_term =~ /@/    #<== returns position where found the match else nil
      build_for_email_search(search_term)
    else
      build_for_name_search(search_term)
    end
  end
  
  def build_for_name_search(search_term)
    @where_clause << case_insensitive_search(:first_name)
    @where_args[:first_name] = starts_with(search_term)
    @where_clause << " OR #{case_insensitive_search(:last_name)}"
    @where_args[:last_name] = starts_with(search_term)
    @order = "last_name asc"
  end
  
  def starts_with(search_term)
    search_term + "%"
  end
  
  def case_insensitive_search(field_name)
    "lower(#{field_name}) like :#{field_name}"
  end

  #remove everything after the @ as well as any digits.
  def extract_name(email)
    email.gsub(/@.*$/,'').gsub(/[0-9]+/,'')
  end

  def build_for_email_search(search_term)
    @where_clause << case_insensitive_search(:first_name)
    @where_args[:first_name] = starts_with(extract_name(search_term))
    @where_clause << " OR #{case_insensitive_search(:last_name)}"
    @where_args[:last_name] = starts_with(extract_name(search_term))
    @where_clause << " OR #{case_insensitive_search(:email)}"
    @where_args[:email] = search_term
    # @order = "email = '#{search_term}' desc, last_name asc"
    @order = "lower(email) = " + ActiveRecord::Base.connection.quote(search_term) + " desc, last_name asc"
  end

end