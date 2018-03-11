require "erb"
include ERB::Util

module UserHelper

  def user_params(params)
    error = validate_presence_of(params)
    if !validate_email_format(params["email"])
      error << "votre adresse email n'est pas valide"
    end
    if validate_length_of(params["password"], 8)
      error << "votre mot de passe est trop court (8 char min)"
    end
    if (params["login"].present? && !User.validate_uniqueness_of("login", params["login"]))
      error << "ce login est déjà utilisé, merci d'en choisir un autre"
    end
    if (params["email"].present? && !User.validate_uniqueness_of("email", params["email"]))
      error << "cet email est déjà utilisé, merci d'en choisir un autre"
    end
    error
  end

  def update_params(params)
    params['email'] && validate_email_format(params["email"])
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

  def upload_images(params, user)
		c = 0
		params.each do |k,v|
      if valid_format(v['filename'])
  			@img = v['filename']
  			file = v['tempfile']
  			cp(file, "./app/public/files/#{@img}")
  			res = User.update({k => @img}, user)
  			c += 1 unless res.nil?
      end
		end
		if c > 0
			flash.now[:success] = "#{c} image(s) ont été ajoutées a votre profil"
		else
			flash.now[:notice] = "Une erreur est apparue lors de l'upload d'images'"
		end
	end

  def valid_format(img)
    img =~ /.\.(png|jpeg|jpg|gif)$/
  end

  def edit_location(params, user)
    if params['latitude'].valid_float? && params['longitude'].valid_float?
      @user = User.update(params, user)
      return !@user.nil?
    end
  end

  def have_image
    @user.img1 || @user.img2 || @user.img3 || @user.img4 || @user.img5
  end

  def proper_value(value)
    res = @user[value] ? @user[value].force_encoding("UTF-8") : "ND"
    h(res)
  end

  def proper_img(img)
    img ? img : "empty.png"
  end

  def get_img(id)
    User.find_by("id", id).to_dot
  end

  def reported_as_fake?
    @user.reported_as_fake
  end

  def profile_complete?(user)
    c = 25
    user.each do |k,v|
      c -= 1 if v.nil? || v == ""
    end
    ((c.to_f / 25) * 100).to_i
  end

end
