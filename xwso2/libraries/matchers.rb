if defined?(ChefSpec)

  def install_wso2_component(message)
    ChefSpec::Matchers::ResourceMatcher.new(:wso2_component, :install, message)
  end

end
