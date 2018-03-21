class DateFormat

  def self.time_to_words(date)
    a = (Time.now - date).to_i

    case a
    when 0 then "à l'instant"
    when 2..59 then a.to_s+" secondes plus tôt"
    when 60..119 then "il y a une minute" #120 = 2 minutes
    when 120..3540 then "il y a " + (a/60).to_i.to_s + " minutes"
    when 3541..7100 then "il y a une heure" # 3600 = 1 hour
    when 7101..82800 then "il y a " + ((a+99)/3600).to_i.to_s + " heures"
    when 82801..172000 then "il y a un jour" # 86400 = 1 day
    when 172001..518400 then "il y a " + ((a+800)/(60*60*24)).to_i.to_s + " jours"
    when 518400..1036800 then "il y a une semaine"
    else "il y a " + ((a+180000)/(60*60*24*7)).to_i.to_s + " semaines"
    end
  end

end
