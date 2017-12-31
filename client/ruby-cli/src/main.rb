require 'curb'

def print_banner
  puts '~~~ Devlunch Picker Client 0.0.1 ~~~'
end

def print_menu
  status = 'unknown'
  puts "Current status: #{status}"
  main_menu = <<-MAINMENU
  Sign up:
  [1] +1
  [2] coming, but not voting
  [3] not coming
  [4] change pick
  [5] change nickname
  [6] change name

  See info:
  [7] Who's going
  [8] Where are we going
  [9] Lunch rules

  MAINMENU

  puts main_menu
end

def get_input

end

def main
  client = DevlunchClient.new

  # read
  print_banner
  print_menu
  option = gets.chomp
  puts option
  # exec
  case option
  when 1
    client.plusone
  when 2
    client.joining
  when 3
    client.back_out
  when 4
    puts 'Enter your pick:'
    pick = gets.chomp
    client.edit pick: pick
  when 5
    puts 'Enter a nickname:'
    nick = gets.chomp
    client.edit nickname: nick
  when 6
    puts 'Enter your real name:'
    name = gets.chomp
    client.edit name: name
  when 7
    puts 'Here\'s who\'s going:'
    client.view_status
  when 8
    puts 'We are going to:'
    client.view_result
  when 'q'
    puts 'Try Ctrl-c instead!'
  end

  # prnt
  # loop
end

class DevlunchClient
  def initialize() end

  URL = 'http://localhost'.freeze

  def login(uname, passwd)
    # post to  '/login'
    
  end

  def change_info(**options)
    Curl.post("#{URL}/edit", options)
  end

  def plusone(pick="")
  end

  def set_joining

  end

  def not_coming
    Curl.get("#{URL}/users").body_str
  end

  def view_status
    Curl.get("#{URL}/users").body_str
  end

  def view_users_joining
    Curl.get("#{URL}/users/joining").body_str
  end

  def view_users_voting
    Curl.get("#{URL}/users/voting").body_str
  end
end

main
