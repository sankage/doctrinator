class DNAParser
  EFT_SLOT_ORDER = [:low, :med, :high, :rig, :subsystem]
  attr_reader :dna
  def initialize(dna:, name: "")
    @dna = dna
    @name = name
    @parts = dna[/(\d+?:[\d:;]*?::)/, 1].split(":")
    @modules = {}
    @drones = []
    @cargo = []
    parse_dna
  end

  def ship_name
    select_item(@parts[0]).name
  end

  def eft
    fitting_name = @name.empty? ? "" : ", #{@name}"
    output = "[#{parse_ship.name}#{fitting_name}]\n"
    EFT_SLOT_ORDER.each do |slot|
      if @modules[slot]
        @modules[slot].each do |part, quantity|
          quantity.times do
            output << part.name << "\n"
          end
        end
        output << "\n"
      end
    end
    @drones.each do |drone, quantity|
      output << drone.name << " x#{quantity}\n"
    end
    @cargo.each do |item, quantity|
      output << item.name << " x#{quantity}\n"
    end
    output
  end

  def requirement_dna
    requirements.map { |req| "#{req.skill_id};#{req.level}" }.join(":") << "::"
  end

  private

  def items
    @items ||= begin
      part_ids = @parts.map { |part| part.split(";").first }
      Static::Item.includes(:effects, group: :category).where(typeID: part_ids)
    end
  end

  def item_ids
    items.map(&:typeID)
  end

  def select_item(item_id)
    items.detect { |i| i.typeID == item_id.to_i }
  end

  def requirements
    @requirements ||= Requirement.from_item_ids(item_ids)
  end

  def parse_dna
    @parts[1..-1].each do |part|
      item_id, quantity = part.split(";")
      item = select_item(item_id)

      case item.category.name
      when "Drone" then @drones << [item, quantity.to_i]
      when "Charge" then @cargo << [item, quantity.to_i]
      else
        slot = parse_slot(item)
        @modules[slot] = [] unless @modules[slot]
        @modules[slot] << [item, quantity.to_i] if slot
      end
    end
  end

  SLOT_MAP = {
    "loPower" => :low,
    "hiPower" => :high,
    "medPower" => :med,
    "subSystem" => :subsystem,
    "rigSlot" => :rig
  }
  private_constant :SLOT_MAP

  def parse_slot(item)
    item.effects.each do |effect|
      if SLOT_MAP.include?(effect.name)
        return SLOT_MAP[effect.name]
      end
    end
    return nil
  end
end
