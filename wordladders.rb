# IT Universitet i København - Algorithm Design Course (2010)
# ex2: Word ladders (graph trasversal)
# Passes al the tests
# author: Alex Usbergo (aleu@itu.dk)

def valid_distance? (from, to)
  chars = from.to_s[1..4].split(//) 
  to.to_s.split(//).each{|c| chars.delete_at(chars.index(c)) if chars.include?(c)}
  return (4 - chars.size) > 3
end

def hash_function (word)
  v = 0; word.split(//).each{|c| v += c[0] - 97}; return v;
end

def create_graph (file)
  #graph
  graph = {}; file.read.split.each{ |w| graph[w.to_sym] = [] }
  
  #hash support structure
  hashc = {}
  graph.keys.each do |k|
    h = hash_function(k.to_s)
    hashc[h] = [] if hashc[h].nil?
    hashc[h] << k
  end
    
  graph.keys.each do |w|    
    h = hash_function(w.to_s); q = []; 
    25.times do |i| 
      h = hash_function(w.to_s[1..4]) 
      graph[w] += hashc[h+i].select{|j| j = valid_distance?(w, j) && j != w}  unless hashc[h+i].nil?
    end    
  end 
  return graph
end

#breadth first search that counts the number of hops from the word s 
#to the word e in O(m+n)
def bfs (graph, s, e)
  return 0 if s == e
  q = []; q << s; v = {}; f ={};
  
  #bfs search
  found = false;
  while (!q.empty? && !found) do
    node = q.shift
    found = true if node == e
    graph[node].each{|n| begin q.push(n); f[n] = node; v[n] = true end unless v[n]} unless found
  end
  
  #count the hops
  count = 0; i = e; begin i = f[i]; count += 1 end while (i != s && found)
  return count = found ? count : -1
end

#main
Process.exit if ARGV[0].nil? || ARGV[1].nil?

#create the graph
graph = create_graph File.open(ARGV[0])
#bfs search
t = File.open(ARGV[1]).read.split; 
while !t.empty? do puts bfs(graph, t.shift.to_sym, t.shift.to_sym) end
