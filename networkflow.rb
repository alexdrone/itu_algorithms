# IT Universitet i København - Algorithm Design Course (2010)
# ex6: Network Flow
# Passes al the tests
# author: Alex Usbergo (aleu@itu.dk)
Struct.new("Edge", :source, :sink, :capacity, :reverse, :flow, :residual)

class NetworkFlow
  attr_reader :adj, :flow, :labels
  
  def initialize(vertices, source, sink)
    @adj, @flow, @labels = [], {}, vertices
    @source = source
    @sink = sink    
    vertices.size.times{|i| @adj[i] = []}
  end
  
  def [](e)
    return adj[e]
  end
  
  def add(u, v, w)
    w = 1.0/0 if (w == -1) 
    
    s_edge = Struct::Edge.new(u, v, w.to_f, nil, 0, w)
    r_edge = Struct::Edge.new(v, u, w.to_f, nil, 0, w)
    
    s_edge.reverse = r_edge
    r_edge.reverse = s_edge
    
    @adj[u] << s_edge
    @adj[v] << r_edge
  end
    
  def find_path(source, sink, path)
    return path if source == sink
    
    @adj[source].each do |e|
      e.residual = e.capacity - e.flow
      if e.residual > 0 && !path.map{|x| [x.source, x.sink]}.flatten.include?(e.sink)
        result = self.find_path(e.sink, sink, path + [e])
        return result if !result.empty?
      end
    end
    []
  end
  
  def min_cut
    #bfs
    queue = []
    queue << @source
    
    #visited nodes
    vis = []; @labels.size.times{|i| vis[i] = false}; vis[@source] = true
    
    while !queue.empty?
      v = queue.shift; vis[v] = true
      @adj[v].each{|e| queue << e.sink if e.residual > 0 && !vis[e.sink]}
    end
    
    #A and B sets
    a = []; vis.size.times{|i| a << i if  vis[i]}
    b = []; vis.size.times{|i| b << i if !vis[i]}
    
    min_cut = []
    a.each{|v| min_cut << @adj[v].select{|e| b.include?(e.sink)}}    
    min_cut.flatten    
  end
    
  def max_flow
    path = find_path(@source, @sink, [])
    last_flow = 0
    
    while !path.empty?
      flow = path.map{|e| e.residual}.min
      path.each{|e| e.flow += flow; e.reverse.flow -= flow}
      path = self.find_path(@source, @sink, [])
    end
    
    max_flow = 0; @adj[@source].each{|e| max_flow += e.flow}
    [max_flow, min_cut]
  end  
end

file = File.new("data/rails.txt")
v = []; file.readline.split.first.to_i.times{|i| v << file.readline.split.first}
network = NetworkFlow.new(v, 0, 54)

file.readline.split.first.to_i.times do |i|
  f, t, c = file.readline.split.map{|x| x.to_i}
  network.add(f, t, c)
end  
 
max_flow, min_cut = network.max_flow
puts max_flow, min_cut.map{|e| [e.source,e.sink,e.capacity]}.inspect
