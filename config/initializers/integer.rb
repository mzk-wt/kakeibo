class Integer
  def to_c
    str = to_s
    tmp = ""
    while(str =~ /([-+]?.*\d)(\d\d\d)/) do
      str = $1
      tmp = ",#{$2}" + tmp
    end
    str + tmp
  end
end

