module AuthenticationHelper

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
