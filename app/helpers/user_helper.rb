module UserHelper

  def user_params(params)
    error = validate_presence_of(params)
    if !validate_email_format(params["email"])
      error << "votre adresse email n'est pas valide"
    end
    if validate_length_of(params["password"], 8)
      error << "votre mot de passe est trop court (8 char min)"
    end
    if (params["login"].present? && !validate_uniqueness_of("login", params["login"], "User"))
      error << "ce login est déjà utilisé, merci d'en choisir un autre"
    end
    if (params["email"].present? && !validate_uniqueness_of("email", params["email"], "User"))
      error << "cet email est déjà utilisé, merci d'en choisir un autre"
    end
    error
  end

  def validate_presence_of(params)
    error = []
    params.each do |k, v|
      if !v.present?
        error << k + " : ne peut pas être vide"
      end
    end
    error
  end

  def validate_email_format(email)
    email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  end

  def validate_length_of(param, len)
    param.length < len
  end

  def validate_uniqueness_of(param, value, table_name)
    $server.query("SELECT * FROM #{table_name} WHERE #{param} = '#{value}'").num_rows == 0 ? TRUE : FALSE
  end

end
