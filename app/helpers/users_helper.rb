module UsersHelper
  def self.get_filtered(filter)
    users = User

    if(filter[:status] != nil)
      users = users.where('users.status = ?', filter[:status])
    end
    
    if(filter[:search] != nil)
      users = users.joins(:profile)
      users = users.where('LOWER(profiles.first_name) LIKE :search OR LOWER(profiles.last_name) LIKE :search OR LOWER(users.email) LIKE :search OR LOWER(users.username) LIKE :search', {search: "%" + Book.sanitize_sql_like(filter[:search].downcase) + "%"})
    end

    if(filter[:type] != nil)
      users = users.where('users.user_type = ?', filter[:type])
    end

    users
  end
end