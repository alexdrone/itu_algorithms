# IT Universitet i København - Algorithm Design Course (2010)
# ex4: Closest Pair
# Passes al the tests
# author: Alex Usbergo (aleu@itu.dk)

require "bigdecimal"
require "bigdecimal/util"

def fetch_data(file)
  points = []
  begin line = file.readline end while line.split.first != "NODE_COORD_SECTION"
  while !file.eof?
    line = file.readline; break if line.split.first == "EOF" || line.split.size < 3;
    label, x, y = line.split
    points << {:label => label, :x => x.to_d, :y => y.to_d}
  end
  return points
end

#distance between two points
def distance(p, q)
  Math.hypot(p[:x] - q[:x], p[:y] - q[:y])
end

#is the bruteforce algorithm used just for compute the solution of 
#sets with cardinality 3.
def bruteforce(p)
  p_min = []
  d_min = BigDecimal.new("+Infinity")
  p.size.times do |i|
    for j in i+1..p.size-1 do
      d = distance(p[i], p[j])
      begin d_min = d; p_min = [p[i], p[j]] end if d < d_min
    end
  end 
  return [d_min, p_min] 
end

#An algorithm based on the recursive dividi et impera approach
#which is O(n log n)
def closest_pair(points)
  return bruteforce(points) if points.size < 4
  
  d_l, p_l = closest_pair(points[0..points.size/2])
  d_r, p_r = closest_pair(points[points.size/2..-1])
  
  d_min = d_l < d_r ? d_l : d_r
  pair  = d_l < d_r ? p_l : p_r
  
  #y_sorted  ← { p ∈ {points y-sorted} : |points[:x] - p[:x]| < d_min }
  y_sorted = points.select{|p| !p[:x].nil? && (p_l[-1][:x] - p[:x]).abs < d_min}.sort{|x,y| x[:y] <=> y[:y]}
  closest, closest_pair = BigDecimal.new("+Infinity"), []
  
  for i in 0..y_sorted.size-2 do
    for j in i+1..y_sorted.size-1 do  
      #the nested loop continues while [j][:y] - [i][:y] < d_min
      break if (y_sorted[j][:y] - y_sorted[i][:y]) >= d_min
      d = distance(y_sorted[i], y_sorted[j])
      begin closest = d; closest_pair = [y_sorted[i], y_sorted[j]] end if d < closest
    end
  end
  result = closest < d_min ? [closest, closest_pair] : [d_min, pair]
  return result  
end

Dir.foreach("data") do |f|
  puts " #{f} \t\t: " + closest_pair(fetch_data(File.open("data/#{f}")).sort!{|x,y| x[:x] <=> y[:x]})[0].to_s if (f[-3..-1] == 'tsp')
end


