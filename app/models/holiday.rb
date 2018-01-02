class Holiday

  HOLIDAYS = {"Groundhog Day" => "groundhogday",
              "Valentine's Day" => "",
              "St. Patrick's Day" => "",
              "April Fool's Day" => "",
              "Good Friday" => "",
              "Easter Sunday" => "easter",
              "Easter Monday" => "easter",
              "Earth Day" => "",
              "Cinco de Mayo" => "cincodemayo",
              "Mother's Day" => "mothersday",
              "Memorial Day" => "summer",
              "Father's Day" => "fathersday",
              "Independence Day" => "independenceday",
              "Labor Day" => "",
              "Thanksgiving" => "",
              "Halloween" => "halloween",
              "Thanksgiving" => "",
              "Nochebuena" => "christmas",
              "Christmas Day" => "christmas",
              "New Year's Day" => "newyear"}

  def initialize
    t = Date.today
    date = Date.civil(t.year, t.month, t.day)
    @holidays = Holidays.on(date, :informal, :us)
  end

  def holiday_tag
    tags = []
    @holidays.each do |h|
      tags << HOLIDAYS[h[:name]]
    end
    tags.sample
  end

  def holiday?
    @holidays.any? {|h| HOLIDAYS.keys.include?(h[:name])}
  end

  def holiday_list
    HOLIDAYS.compact
  end
end
