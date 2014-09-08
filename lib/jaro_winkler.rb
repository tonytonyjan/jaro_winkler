require 'jaro_winkler/fallback'
require 'jaro_winkler/jaro_winkler.so' unless JaroWinkler.fallback?
module JaroWinkler
  module_function
  def jaro_distance s1, s2
    length1, length2 = s1.length, s2.length
    # Guarantee the length order
    if s1.length > s2.length
      s1, s2 = s2, s1
      length1, length2 = length2, length1
    end
    window_size    = (length2 / 2) - 1
    window_size    = 0 if window_size < 0
    matches        = 0.0
    transpositions = 0
    previous_index = -1
    max_index      = length2 - 1
    s1.chars.each_with_index do |c1, i|
      left      = i - window_size
      right     = i + window_size
      left      = 0         if left  < 0
      right     = max_index if right > max_index
      matched   = false
      found     = false
      s2[left..right].chars.each_with_index do |c2, j|
        if c1 == c2
          matched  = true
          s2_index = left + j
          if !found && s2_index > previous_index
            previous_index = s2_index
            found          = true
          end
        end
      end
      if matched
        matches += 1
        transpositions += 1 unless found
      end
    end
    # Don't divide transpositions by 2 since it's been counted directly by above code.
    matches == 0 ? 0 : (matches / length1 + matches / length2 + (matches - transpositions) / matches) / 3.0
  end

  def r_distance s1, s2, options = {}
    options = {weight: 0.1, threshold: 0.7, ignore_case: false}.merge options
    weight, threshold, ignore_case = options[:weight], options[:threshold], options[:ignore_case]
    raise 'Scaling factor should not exceed 0.25, otherwise the distance can become larger than 1' if weight > 0.25
    s1, s2     = s1.upcase, s2.upcase if ignore_case
    distance   = jaro_distance(s1, s2)
    prefix     = 0
    max_length = [4, s1.length, s2.length].min
    s1[0, max_length].chars.each_with_index do |c1, i|
      c1 == s2[i] ? prefix += 1 : break
    end
    distance < threshold ? distance : distance + ((prefix * weight) * (1 - distance))
  end

  if JaroWinkler.fallback?
    alias :distance :r_distance
    alias :c_distance :r_distance
    module_function :distance, :c_distance
  else
    alias :distance :c_distance
    module_function :distance
  end
end