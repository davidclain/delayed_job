class ActiveRecord::Base
  yaml_as "tag:ruby.yaml.org,2002:ActiveRecord"

  def self.yaml_new(klass, tag, val)
    account = Account.find_by_subdomain(val['attributes']['account_subdomain'])
    ::ActiveRecord::Base.establish_connection(
		  :adapter	=> 'mysql',
		  :host			=> account.database.host,
		  :database	=> account.database.name,
		  :username	=> account.database.username,
		  :password	=> account.database.password
    )

    klass.find(val['attributes']['id'])
  rescue ActiveRecord::RecordNotFound
    raise Delayed::DeserializationError
  end

  def to_yaml_properties
    ['@attributes']
  end
end
