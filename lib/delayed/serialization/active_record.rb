class ActiveRecord::Base
  yaml_as "tag:ruby.yaml.org,2002:ActiveRecord"

  def self.yaml_new(klass, tag, val)
    account = Account.find_by_subdomain(val['attributes']['account_subdomain'])

    if account
      ::ActiveRecord::Base.establish_connection(
		    :adapter	=> 'mysql',
		    :host			=> account.database.host,
		    :port			=> account.database.port,
		    :database	=> account.database.name,
		    :username	=> account.database.username,
		    :password	=> account.database.password
      )

      # Use the right Websolr URL
      Sunspot.config.solr.url = account.websolr_url
    end

    klass.find(val['attributes']['id'])
  rescue ActiveRecord::RecordNotFound
    raise Delayed::DeserializationError
  end

  def to_yaml_properties
    ['@attributes']
  end
end
