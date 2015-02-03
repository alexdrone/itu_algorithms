# IT Universitet i København - Algorithm Design Course (2010)
# ex3: Spanning USA (MST)
# Passes al the tests
# author: Alex Usbergo (aleu@itu.dk)

class UnionFind  
  #A disjoint-set data structure that keeps track of partitioning.
  def initialize  
    @elements = {}
  end
  #The find operation determines which set a particular element is in or 
  #if two elements are in the same set.
  def [](e)
    return @elements[e]
  end
  #Makeset operation
  def <<(e)
    @elements[e] = e
  end
  #Combine or merge two sets into a single set.
  def union(l, e)
    self << l if @elements[l].nil?
    old = @elements[e]
    @elements.keys.each{|k| @elements[k] = @elements[l] if @elements[k] == old}
  end
end

#Finds a minimum spanning tree for a connected weighted graph. 
def kruskal(edges)
  mst = Hash.new
  set = UnionFind.new
  count = 0
  edges.sort!{|x,y| x[:val] <=> y[:val]}
  edges.each do |e|
    set << e[:f] if set[e[:f]].nil?
    set << e[:t] if set[e[:t]].nil?
    
    if set[e[:t]] != set[e[:f]] 
      mst[e[:f]] = [] if mst[e[:f]].nil?
      mst[e[:f]] << {:t => e[:t], :val => e[:val]}
      
      set.union(e[:f], e[:t]) 
      count += e[:val]
    end
  end    
  count # => 16598
  return mst
end                

def fetch_data(size, file)
  size.times{|t| file.readline}
  edges = Array.new  
  
  while !file.eof?
    line = file.readline.split(/("[^"]+"|\w+)--("[^"]+"|\w+)\s*\[(\d*)\]/)    
    n = line[1].split(/"([^"]+)"|(\w+)/)[1].to_sym
    m = line[2].split(/"([^"]+)"|(\w+)/)[1].to_sym
    edges << {:f => n, :t => m, :val => line[3].to_i}
  end
  return edges
end

edges = fetch_data(128, File.open("data/usa.in"))
mst = kruskal(edges)
