# A set of senators searchable by name
class SenatorsByName < Senators
  # Cleans a senator name for the @by_name hash.
  private def clean(name)
    name.downcase.tr('-.', ' ').strip.squeeze(' ')
  end

  def initialize(senators)
    @all = senators.all

    @by_name = {}
    dups = Set.new
    all.each do |senator|
      name = senator.name
      names = [name.first, name.last, name.full, name.first_last]
      names.map! { |name| clean(name) }.uniq!
      names.each do |name|
        if @by_name.has_key? name
          dups << name
        else
          @by_name[name] = senator
        end
      end
    end
    dups.each { |name| @by_name.delete name }
  end

  def by_name(name)
    @by_name[clean(name)]
  end
end
