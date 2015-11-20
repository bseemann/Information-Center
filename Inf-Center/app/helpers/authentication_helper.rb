module AuthenticationHelper


  def take_name(name)
    if name.scan("/").count >= 2
      name = name.split("/").last
    else
      name = name[1..-1]
    end
    name
  end

  def date_format(date)
    date.split("+").first
  end

  def get_type(file)
    if file.include? "." then
      type = file.split(".").last.upcase
    else
      type = "sem ext."
    end
    type
  end

  def take_length(path)
    $root_metadata.each do |hash|
      if hash["path"] == path then
        @length = unit(hash["bytes"])
      end
    end
    return @length
  end

  def unit(number)

    if number >= (1024**3) then
      number = number/(1024**3)
      unit = 'GB'
    elsif number >= (1024**2) then
      number = number/(1024**2)
      unit = 'MB'
    elsif number >= (1024) then
      number = number/(1024)
      unit = 'KB'
    else
      unit = 'Bytes'
    end
    units = "#{number} #{unit}"
  end


end
