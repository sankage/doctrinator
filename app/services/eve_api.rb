class EveAPI
  def initialize(api_key)
    @api_key = api_key
    @key_id = api_key.key_id
    @v_code = api_key.v_code
    @apis = {}
  end

  def characters
    result = api_with_scope("account").Characters
    result.characters
  rescue EAAL::Exception.EveAPIException(106)
    @api_key.incorrect!
    []
  rescue EAAL::Exception.EveAPIException(221)
    @api_key.no_access!
    []
  rescue EAAL::Exception.EveAPIException(222)
    @api_key.expired!
    []
  end

  def skills(character_id)
    result = api_with_scope("char").CharacterSheet(characterID: character_id)
    result.skills
  rescue EAAL::Exception.EveAPIException(106)
    @api_key.incorrect!
    []
  rescue EAAL::Exception.EveAPIException(221)
    @api_key.no_access!
    []
  rescue EAAL::Exception.EveAPIException(222)
    @api_key.expired!
    []
  end

  private

  def api_with_scope(scope)
    @apis[scope] ||= EAAL::API.new(@key_id, @v_code, scope)
  end
end


# Error Codes
#
# 221: Illegal page request! Please verify the access granted by the key you are
# using!
#
# 106: Must provide userID or keyID parameter for authentication.
#
# 222: Key has expired. Contact key owner for access renewal.
