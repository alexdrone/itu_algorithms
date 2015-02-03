#Querella Luca 10/10/2010
#CLOSEST PAIRS IN THE PLANE
#CP.rb
#use with: ruby CP.rb [..] (tested with ruby [..])

require 'bigdecimal'
require 'bigdecimal/util'


#DEFS
def distance(p1,p2)
  (((p1[:x] - p2[:x])**2) + ((p1[:y] - p2[:y])**2)).sqrt(2)
end

def shortes(points)  
  if points.size == 2
    return [[points[0],points[1]], distance(points[0],points[1])]
  elsif points.size == 3
    a = distance(points[0],points[1])
    b = distance(points[1],points[2])
    c = distance(points[2],points[0])
    if a <= b && a<=c
      return [[points[0],points[1]], a]
    elsif b <= c 
      return [[points[1],points[2]], b]
    else
      return [[points[2],points[0]], c]
    end
  else
    return nil
  end
end

#CLOSEST PAIRS ALGORITM
def procedure(points)
  
  xpoints = points.sort!{|a,b| a[:x] <=> b[:x] }
  ypoints = points.sort!{|a,b| a[:y] <=> b[:y] }
  
  return shortes(xpoints)  if xpoints.size < 4

  xpoints_left = xpoints[0..xpoints.size/2-1]
  xpoints_right = xpoints[xpoints.size/2..-1]
  cut = xpoints_left.last[:x]


  shortes_left_points, shortes_left_distance = procedure([0..points.size/2])
  shortes_right_points, shortes_right_distance = procedure([points.size/2+1..points.size])

  shortes_points = shortes_left_distance <= shortes_right_distance ? shortes_left_points : shortes_right_points
  shortes_distance = shortes_left_distance <= shortes_right_distance ? shortes_left_distance : shortes_right_distance

  candidate = ypoints.select{|a| (a[:x] - cut).abs < shortes_distance }

  0.upto(candidate.size-2) do |i|
     (i+1).upto(candidate.size-1) do |j|  
       break if (candidate[j][:y] - candidate[i][:y]) >= shortes_distance
       if (d = distance(candidate[i], candidate[j])) < shortes_distance
         shortes_distance,shortes_points =d, [candidate[i], candidate[j]]
       end
     end
   end

   return [shortes_points,shortes_distance]
end



#INPUT && OUTPUT:
files = Dir["*.tsp"].each do |file|
  file_in = File.open(file) 
  inputs = file_in.read.split("\n")

  points = []
  inputs.each do |input|
    if (str = input.match(/^\s*([0-9]+)\s*([^\s]*)\s*([^\s]*)$/))
      points << {:x => BigDecimal.new(str[2]), :y => BigDecimal.new(str[3])}
    end
  end




  x = procedure(points)
  puts "#{file}:#{points.size} - #{x[1].to_f} "
x
end