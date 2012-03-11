module Brainz
  class Brainz
    def self.load(file_name)
      Marshal.load(File.read(file_name))
    end

    def save(file_name)
      File.open(file_name, 'wb') { |file| file.write(Marshal.dump(self)) }
    end
  end
end