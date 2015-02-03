# IT Universitet i København - Algorithm Design Course (2010)
# ex1: Gale-Shapley stable matching algorithm implementaton
# passes al the tests
# author: Alex Usbergo (aleu@itu.dk)

Process.exit if ARGV[0].nil?

# - fetching data from file
FILE = File.open(ARGV[0], "r")
begin line = FILE.readline end while line.match(/^#/); size = line.split("=")[1].to_i

#reading names and values
names = []; size.times{names << {:m => FILE.readline.split[1], :w => FILE.readline.split[1]} }
begin line = FILE.readline end while line.match(/\n#/)
values = {:m => [], :w => []}; i = 0

while (!FILE.eof?) do
  data = FILE.readline.split(":")[1].to_s.split.map{|x| (x.to_i - 1)/2}
  if i.even?  
    values[:m][i/2] = data
  else 
    inversed = []
    data.size.times{|t| inversed[data[t]] = t}
    values[:w][i/2] = inversed
  end  
  i = i + 1 
end

# - gale shapley algorithm implementation
matchings = {:m => values[:m].size.times.map{nil}, :w => values[:w].size.times.map{nil}}

#the first unmatched m
m = matchings[:m].index(nil)

while (!m.nil?)
  matched = false
  
  #proposing
  while (!matched && !values[:m][m].empty?)
              
    #m's highest ranked such w who he has not proposed to yet
    w = values[:m][m].shift

    if matchings[:w][w].nil? || values[:w][w][m] < values[:w][w][matchings[:w][w]]
              
      #set unmatched the previous w's m
      matchings[:m][matchings[:w][w]] = nil unless matchings[:w][w].nil? 
      matchings[:w][w] = m
      matchings[:m][m] = w
         
      matched = true
    end
  end
  
  #impossible matching
  Process.exit unless matched
  
  #again, the first unmatched m
  m = matchings[:m].index(nil)
end

# - output
matchings[:m].size.times{|i| print "#{names[i][:m]} -- #{names[matchings[:m][i]][:w]}\n"}

