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
    text = date.split("+").first
    text = text.split(" ")
    text = text[1..-1]
    month_hash = {"Jan" => 1, "Feb" => 2, "Mar" => 3, "Apr" => 4, "May" => 5, "Jun" => 6, "Jul" => 7, "Aug" => 8, "Sep" => 9, "Oct" => 10, "Nov" => 11, "Dec" => 12 }
    month = month_hash[text[1]]
    date = "#{text[0]}/#{month}/#{text[2]}, #{text[3]}"
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

  #@param path, path of the file you want to download
  def download(path)
    $client.shares(path)
    #shareble_link = $client.shares(path)
    res = Net::HTTP.get_response(URI("#{$client.shares(path)['url']}"))
    a = "#{res['location'].to_s[0...-1]}1"
  end

  def navigation(root)
    dirs = root.split("/")
    path = Array.new

    dirs.each_with_index do |l,i|
      path << dirs[0..i].join("/")
    end
    path.delete("")
    
    return path
  end

 #link_to l, authentication_navigation_params(:parent_id => path, :page => 1) 
end
