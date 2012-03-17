module Brainz
  class Synapse
    attr_reader :from, :to, :weight
    attr_accessor :change

    def initialize(from, to)
      @weight = Kernel.rand(0.4) - 0.2
      @change = 0
      @from, @to = from, to
    end

    def adjust(diff)
      @weight += diff
    end

    def self.link(from, to)
      synapse = Synapse.new(from, to)
      to.dendrites.push(synapse)
      from.axon_synapses.push(synapse)
    end
    Kernel.srand(Time.now.to_i)
  end
end