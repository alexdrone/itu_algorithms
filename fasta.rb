# IT Universitet i København - Algorithm Design Course (2010)
# ex5: Sequence Alignment
# Passes al the tests
# author: Alex Usbergo (aleu@itu.dk)

def fetch_data(matrix_filename, input_filename)
  f = File.open(matrix_filename)  
  blosum = Hash.new; columns = f.readline.split[0..-1].map{|c| c.to_sym}

  while (!f.eof?) do
    values = f.readline.split[0..-1]; row = values.shift.to_sym
    columns.each{|c| blosum[c] = {} if blosum[c].nil?; blosum[c][row] = values.shift.to_i}  
  end
  
  f = File.open(input_filename);input = []
  f.read.split(">")[1..-1].each do |c| 
    input << {:name => c.split("\n")[0].split[0], 
              :data => c.split("\n")[1..-1].join.split(//).map{|c| c.to_sym}}
  end
  return [blosum, input]
end

def seqalign(x, y, m, blosum)
  0.upto(x.size){|i| m[i] = [-4 * i]}
  0.upto(y.size){|i| m[0][i] = -4 * i}

  1.upto(x.size) do |i|
    1.upto(y.size) do |j|
      m[i][j] = [blosum[x[i-1]][y[j-1]] + m[i-1][j-1], -4 + m[i-1][j], -4 + m[i][j-1]].max
    end
  end
  return m[-1][-1]
end

def seqprint(x, y, m, blosum)
  a_x, a_y, i, j  = [], [], x.size, y.size
  
  while (i>0 && j>0)  
    #match
    if m[i][j] == m[i-1][j-1] + blosum[x[i-1]][y[j-1]] 
      a_x << x[i-1]; a_y << y[j-1]; 
      j -= 1
      i -= 1
    #gaps
    elsif m[i][j] == -4 + m[i][j-1]
      a_x << :-; a_y << y[j-1]
      j -= 1
      
    elsif m[i][j] == -4 + m[i-1][j]
      a_x << x[i-1]; a_y << :-
      i -= 1    
    end
  end
  
  begin a_x << x[i-1]; a_y << :-; i -= 1 end while i > 0
  begin a_y << y[j-1]; a_x << :-; j -= 1 end while j > 0
  a_x.reverse_each.map.join
  a_y.reverse_each.map.join
  
  puts "#{a_x}\n#{a_y}\n\n"
end

blosum, input = fetch_data("data/BLOSUM62.txt","data/HbB_FASTAs.in")
for i in 0..input.size-1 do
  for j in i+1..input.size-1 do
    matrix = []; value  = seqalign(input[i][:data], input[j][:data], matrix, blosum)
    puts "#{input[i][:name]}--#{input[j][:name]}: #{value}"
    seqprint(input[i][:data], input[j][:data], matrix, blosum)
  end
end