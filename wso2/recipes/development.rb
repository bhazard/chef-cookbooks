# Configure the development environment for all wso2 components
# ------------------------------------------------------------------------------

include_recipe 'vim'

# The following are used to build and install samples.  Different components
# may use one or more of these, depending on the component.
#include_recipe 'subversion::client'
# include_recipe 'maven'
# include_recipe 'ant'