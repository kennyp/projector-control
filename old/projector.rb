require 'net/http'
require 'uri'
require 'rubygems'
require 'hpricot'

def login(proj_ip,user,pass)
  response = Net::HTTP.post_form URI.parse("http://#{proj_ip}/index.html"), { "DATA1" => user.to_s, "DATA2" => pass.to_s }
  response.body.include? "sts = \"2\";"
end

def logout(proj_ip)
  Net::HTTP.post_form URI.parse("http://#{proj_ip}/logout.html"), { "L1" => "1" }
end

settings = {
  :url => "admin/main.html",
  :controls => {
    :power => {
      :on  => { "V1" => 1, "D1" => 1 },
      :off => { "V2" => 1, "D2" => 0 }
    },
    :blank => {
      :on  => { "V5" => 1, "D5" => 1 },
      :off => { "V6" => 1, "D6" => 0 }
    },
    :freeze => {
      :on  => { "V9"  => 1, "D9"  => 1 },
      :off => { "V10" => 1, "D10" => 0 }
    }
  }
}

settings[:controls].each_key do |ctl|
  settings[:controls][ctl].each_key do |cmd|
    eval <<-EOM
      def #{ctl.to_s}_#{cmd.to_s}(proj_ip,user,pass)
        login(proj_ip,user,pass)
        Net::HTTP.post_form URI.parse("http://\#{proj_ip}/#{settings[:url]}"),
                                    #{settings[:controls][ctl][cmd].inspect}
        logout(proj_ip)
      end
    EOM
  end
end

def status(proj_ip,user,pass)
  login(proj_ip,user,pass)
  response = Net::HTTP.get URI.parse("http://#{proj_ip}/admin/status_a.html")
  stats = {}
  doc = Hpricot.parse(response)
  (doc/".item_name_area").each_with_index do |item,i|
    value_block = (((doc/".item_oparation_area")[i])/:script).innerHTML
    value_block =~ /sts\s=\s"(\d)"/
    stats[item.innerHTML.to_s] = $1
  end
  logout(proj_ip)
  return { :power => stats["Power Status"].to_i, :blank => stats["Blank On/Off"].to_i, :freeze => stats["Freeze"].to_i }
end