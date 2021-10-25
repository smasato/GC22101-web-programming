# frozen_string_literal: true

def count
  result = Hash.new(0)
  File.open(File.expand_path('sample3-1.txt', __dir__), 'r:UTF-8') do |f|
    f.each_line do |l|
      result[l.to_s.strip.chomp] += 1
    end
  end
  result.each do |k, v|
    puts("#{k} = #{v}")
  end
end

count
