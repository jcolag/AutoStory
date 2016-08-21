require 'csv'

class StoryStage
  @@base_index = 0
  @@all = Array.new
  @@base_level = 10
  attr_accessor :name, :index, :skip, :repeat, :level

  def initialize(name = "Step", skip = 1, repeat = 0, level = 0)
    @index = @@base_index
    @@base_index = @@base_index + 1
    @name = name
    @skip = Integer(skip)
    @repeat = Integer(repeat)
    @level = Integer(level)
  end

  def skip?
    return rand(10) < @skip
  end

  def repeat?
    return rand(10) < @repeat
  end

  def self.Initialize(names = Array.new)
    @@base_index = 0
    names.each do |line|
      next if line.length < 1 or line[0][0] == "#"
      c = StoryStage.new(line[0], line[1], line[2], line[3])
      @@all << c
    end
  end

  def self.each
    @@all.each {|x| yield x}
  end

  def self.each_modified
    @@all.each do |x|
      next if x.skip? or x.level > @@base_level
      yield x
      redo if x.repeat?
    end
  end
end

class DramaticChallenge
  @listChar = nil

  def initialize(descriptor)
    @listChar = Array.new
    return if descriptor.nil? or descriptor.empty?
    descriptor.split('/').each do |x|
      tuple = parse(x)
      @listChar << tuple
    end
  end

  def parse(descriptor)
    s = descriptor.split("_")
    who = s[0]
    obs = Integer(s[1])
    return who, obs
  end

  def choose_modifier(scale, max, minor, major)
    return [ minor ] * scale + [ "" ] * (scale * 2) + [ major ] * (max - scale * 3)
  end

  def choose(characters, roles, experience = 0)
    return "" if @listChar.length == 0
    list = @listChar.clone
    list.each do |x|
      char = characters[x[0]]
      x << char
      x[1] = char.strength + experience + rand(10) - x[1]
    end
    list.sort {|a,b| b[1] <=> a[1]}
    char = list.first[2]
    res = "  "
    if list.length == 1
      diff = (list.first[1] - 10).gcd(0)
      mod = choose_modifier(2, 30, ", barely", ", significantly")[diff]
      res += char.name + " " + (diff >= 0 ? "succeeds" : "fails") + mod + "."
    else
      diff = (list[0][1] - list[1][1]).gcd(0)
      mod = choose_modifier(2,30, ", but barely", ", easily")[diff]
      res += list[0][2].name + " "
      res += diff <= 0 ? "overcomes" : "resists"
      res += " " + list[1][2].name + mod + "."
    end
    return res
  end
end

class DramaticSituation
  @@all = Array.new
  @@base_index = 0
  @@stake = 0
  attr_accessor :template, :index, :challenge, :sitcode

  def initialize(template, challenge = "", code = "")
    @index = @@base_index
    @@base_index = @@base_index + 1
    @template = template
    @challenge = DramaticChallenge.new(challenge)
    @sitcode = code
  end

  def self.Initialize(templates = Array.new)
    @@base_index = 0
    templates.each do |template|
      next if template.length == 0 or template[0][0] == "#"
      c = DramaticSituation.new(template[0], template[1], template[2])
      @@all << c
    end
  end

  def self.choose(charsHash)
    roles = Array.new()
    index = rand(@@all.length)
    t = @@all[index]
    template = String.new(t.template)
    charsHash.each do |title,char|
      r = template.gsub!("[" + title + "]", char.name)
      template.gsub!("[" + title + "Gender]", char.gender)
      template.gsub!("[" + title + "GenderPos]", char.genderpos)
      if r != nil
        roles << title
      end
    end
    options = (0 ... template.length).find_all { |i| template[i,1] == '{' }
    options.reverse.each do |opt|
      close = template.index(?}, opt)
      choices = template[opt + 1 ... close].split(',')
      level = rand(choices.length) + @@stake
      level = choices.length - 1 if level >= choices.length
      template[opt ... close + 1] = choices[level]
    end
    template += t.challenge.choose(charsHash, roles)
    template = "[" + t.sitcode + "] " + template if !t.sitcode.nil?
    return template
  end
end

class Character
  @@all = Array.new
  @@base_index = 0
  @@genders = {"M" => "him", "F" => "her"}
  @@genderps = {"M" => "his", "F" => "her"}
  attr_accessor :index, :role, :sex, :first, :gender, :genderpos, :strength

  def initialize(name = "", role = "", sex = "N", strength = 0)
    @index = @@base_index
    @@base_index = @@base_index + 1
    @name = name
    @role = role
    @sex = sex
    @strength = Integer(strength)
    @gender = @@genders[@sex]
    @genderpos = @@genderps[@sex]
    @first = true
  end

  def name
    nn = @name
    nn += " (" + @role + ")" if @first and !@role.nil?
    @first = false
    return nn
  end

  def self.Initialize(names = Array.new)
    @@base_index = 0
    names.each do |line|
      next if line.length < 1 or line[0][0] == "#"
      c = Character.new(line[0], line[1], line[2], line[3])
      @@all << c
    end
  end

  def self.Random(exclude = nil)
    c = nil
    until c != nil and c != exclude
      c = @@all[rand(@@all.length)]
    end
    return c
  end
end

Character.Initialize(CSV.read("chars.csv"))
StoryStage.Initialize(CSV.read("steps.csv"))
DramaticSituation.Initialize(CSV.read("sit.csv", col_sep: ";"))

titles = %w(Protagonist Antagonist Sidekick Henchman Newcomer)
characters = Hash.new()
titles.each {|t| characters[t] = Character.Random}
puts DramaticSituation.choose(characters)
StoryStage.each_modified do |step|
  puts step.name + ":  " + DramaticSituation.choose(characters)
end

