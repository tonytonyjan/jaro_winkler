module JaroWinkler
  DEFAULT_ADJ_TABLE = Hash.new
  [
    ['A', 'E'], ['A', 'I'], ['A', 'O'], ['A', 'U'], ['B', 'V'], ['E', 'I'], ['E', 'O'], ['E', 'U'], ['I', 'O'],
    ['I', 'U'], ['O', 'U'], ['I', 'Y'], ['E', 'Y'], ['C', 'G'], ['E', 'F'], ['W', 'U'], ['W', 'V'], ['X', 'K'],
    ['S', 'Z'], ['X', 'S'], ['Q', 'C'], ['U', 'V'], ['M', 'N'], ['L', 'I'], ['Q', 'O'], ['P', 'R'], ['I', 'J'],
    ['2', 'Z'], ['5', 'S'], ['8', 'B'], ['1', 'I'], ['1', 'L'], ['0', 'O'], ['0', 'Q'], ['C', 'K'], ['G', 'J'],
    ['E', ' '], ['Y', ' '], ['S', ' ']
  ].each{ |s1, s2|
    if not DEFAULT_ADJ_TABLE.has_key?(s1)
      DEFAULT_ADJ_TABLE[s1] = Hash.new
    end
    if not DEFAULT_ADJ_TABLE.has_key?(s2)
      DEFAULT_ADJ_TABLE[s2] = Hash.new
    end
    DEFAULT_ADJ_TABLE[s1][s2] = DEFAULT_ADJ_TABLE[s2][s1] = true
  }
  DEFAULT_ADJ_TABLE.default = Hash.new
end
