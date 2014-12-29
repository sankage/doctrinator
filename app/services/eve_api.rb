class EveAPI
  def initialize(key_id, v_code)
    @key_id = key_id
    @v_code = v_code
    @apis = {}
  end

  def characters
    result = api_with_scope("account").Characters
    result.characters
  rescue EAAL::Exception.EveAPIException(106)
    # Must provide userID or keyID parameter for authentication.
    []
  rescue EAAL::Exception.EveAPIException(222)
    # Key has expired. Contact key owner for access renewal.
    []
  end

  def skills(character_id)
    result = api_with_scope("char").CharacterSheet(characterID: character_id)
    result.skills
  rescue EAAL::Exception.EveAPIException(106)
    # Must provide userID or keyID parameter for authentication.
    []
  rescue EAAL::Exception.EveAPIException(222)
    # Key has expired. Contact key owner for access renewal.
    []
  end

  private

  def api_with_scope(scope)
    @apis[scope] ||= EAAL::API.new(@key_id, @v_code, scope)
  end
end
