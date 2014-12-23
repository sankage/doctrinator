class EFTParser
  EFT_SLOT_ORDER = [:low, :med, :high, :rig, :subsystem]
  attr_reader :eft, :name, :ship_name
  def initialize(eft:)
    @eft = eft.gsub("\r\n", "\n")
    @parts = @eft.split("\n").reject(&:empty?)
    (@ship_name, @name) = @parts.first.gsub(/[\[\]]/, "").split(", ")
  end

  def dna
    dna = []
    dna << select_item(ship_name).typeID
    parse_eft.to_a.each do |item_id, quantity|
      dna << "#{item_id};#{quantity}"
    end
    dna.join(":") << "::"
  end

  def requirement_dna
    requirements.map { |req| "#{req.skill_id};#{req.level}" }.join(":") << "::"
  end

  private

  def items
    @items ||= begin
      part_names = @parts[1..-1].uniq
      part_names.map! { |part| part.sub(/ x\d+/, "") }
      part_names << ship_name
      Static::Item.includes(:effects, group: :category).where(name: part_names)
    end
  end

  def item_ids
    items.map(&:typeID)
  end

  def select_item(name)
    items.detect { |i| i.name == name }
  end

  def requirements
    @requirements ||= Requirement.from_item_ids(item_ids)
  end

  def parse_eft
    @parts[1..-1].each_with_object({}) do |part, item_counts|
      count = part.match(/ x(\d+)/) { |m| m[1].to_i }
      part_name = part.sub(/ x\d+/, "")
      part_id = select_item(part_name).typeID
      item_counts[part_id] = 0 unless item_counts[part_id]
      item_counts[part_id] += count ? count : 1
    end
  end
end
