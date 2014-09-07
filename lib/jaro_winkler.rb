require 'jaro_winkler/jaro_winkler.so' unless RUBY_PLATFORM == 'java'
module JaroWinkler
  module_function
  def jaro_distance s1, s2
    return 0.0 if s1.empty? || s2.empty?
    length1, length2 = s1.length, s2.length
    window_size      = ([length1, length2].max / 2) - 1
    matches          = 0.0
    transpositions   = 0
    previous_index   = -1
    s1.chars.each_with_index do |c1, i|
      max_index = length2 - 1
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
          unless found
            if s2_index > previous_index
              previous_index = s2_index
              found          = true
            end
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

  def distance s1, s2, options = {}
    options = {weight: 0.1, threshold: 0.7, case_match: false, native: false}.merge options
    return c_distance(s1, s2) if RUBY_PLATFORM != 'java' && options[:native]
    weight, threshold, case_match = options[:weight], options[:threshold], options[:case_match]
    raise 'Scaling factor should not exceed 0.25, otherwise the distance can become larger than 1' if weight > 0.25
    s1, s2 = s1.downcase, s2.downcase if case_match
    distance = jaro_distance(s1, s2)
    prefix = 0
    max_length = [4, s1.length, s2.length].min
    s1[0, max_length].chars.each_with_index do |c1, i|
      c1 == s2[i] ? prefix += 1 : break
    end
    distance < threshold ? distance : distance + ((prefix * weight) * (1 - distance))
  end
end