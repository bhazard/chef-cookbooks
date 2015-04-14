# wso2-cookbook

This cookbook provides recipes to install the following WSO2 modules:

* WSO2 API Manager (am)
* WSO2 Application Server (as)
* WSO2 Business Activity Monitor (bam)
* WSO2 Carbon core (carbon)
* WSO2 Enterprise Mobility Manager (emm)
* WSO2 Enterprise Service Bus (esb)
* WSO2 Identity Server (is)

The project includes a `Vagrantfile` that may be used for creating test instances
for each of these components.  This facilitates recipe testing, but is also
useful for playing with the various WSO2 components.

Note that these recipes work by downloading and unzipping each component.  While
it is feasible to install multiple components on the same server, there will be
configuration conflicts.  With WSO2 components, there would typically be only
a single Carbon server, and components would be configured to use that server.
This might be done by installing features into a single tomcat instance, or by
making configuration changes to support multiple TC instances.  This cookbook
does not account for these scenarios, but might be used as a "starting point"
for implementation.

For more information about the various WSO2 components, see the [WSO2 Website](http://wso2.com/products/).

## To-dos

The cookbook is in the middle of a major update (April 2015).  The core modules 
will install, however many depend on being accessible via localhost in their default config.

* Replace default keystore (see log WARN)
* Fix 'stdin: is not a tty' error in console and in wso2/logs/wso2.err
* Add cert for proper SSL support
* Add support for production database
* Parameterize default admin account and password
* Provide configuration option for separate IS server
* Provide configuration option for separate BAM server
* BAM throws log4j appender error in logs/wso2bam.err (WSO2 BUG?)
* Allow IS portal and dashboard to work when not accessed via localhost
* IS dashboard/portal issue with back to login screen gens "something went wrong during auth process"
* Ensure that logs are rotated / managed
* Configure email for password changes, etc

## Supported Platforms

Built and tested on Ubuntu 14.04 only.

## Attributes

This list is incomplete.  See attributes/default.rb for details.

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['wso2']['install_root']</tt></td>
    <td>string</td>
    <td>Root path for installing the wso2comp-version directory.  Usually <code>/opt</code> or <code>/usr/local</code>.</td>
    <td><tt>/opt</tt></td>
  </tr>
  <tr>
    <td><tt>['wso2']['download_dir']</tt></td>
    <td>string</td>
    <td>Location of downloaded WSO2 zip files.</td>
    <td><tt>Chef::Config[:file_cache_path]</tt></td>
  </tr>
  <tr>
    <td><tt>['wso2']['download_url_base']</tt></td>
    <td>string</td>
    <td>URL hosting the WSO2 tarballs.</td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['wso2']['install_java']</tt></td>
    <td>boolean</td>
    <td>Installs a JDK if true.</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['java']['jdk_version']</tt></td>
    <td>string</td>
    <td>Determines which version of the Oracle JDK to install.</td>
    <td><tt>7</tt></td>
  </tr>
</table>

## Usage

### Use the wso2::component-name Chef Recipe or Role

To install the component using a Chef `run-list`, 
include `recipe[wso2::component-name]` 
or alternatively, `role[wso2component-name]` in your 
node's `run_list`.  For example, the following will install the Business 
Activity Monitor ("bam"):

```json
{
  "run_list": [
    "recipe[wso2::bam]"
  ]
}
```
or use the equivallent role:

```json
{
  "run_list": [
    "role[wso2bam]"
  ]
}
```

### Environments

The recipes support a default environment as well as a `development` and a
`chef-development` environment.  Both of these will install tools to allow
the WSO2 samples to be installed and run (e.g., `subversion` and `maven`).  The
`chef-development` environment is also configured to not start the service to
facilitate reviewing the unzipped directories before the server starts for the
first time.

### Testing with Vagrant

The cookbook includes a `Vagrantfile` to allow for easy testing of the
recipes.  The file defines one vagrant node per component.  For example, there
are separate nodes defined for the ESB and the Application Server.  These 
sandboxes may be used to experiment with the WSO2 components.  To manage them,
use standard `vagrant` commands.

```
vagrant status
```

will provide the status of all component VM's.

```
vagrant up esb
```

will start an instance of the Enterprise Service Bus.

The Vagrantfile uses the excellent 
[hostmanager plugin](https://github.com/smdahlen/vagrant-hostmanager) (if it
is installed) to 
update your hosts file on both the host and guest.  To access a running vm, 
you can point your browser to `https://component:9443/carbon`.  For example, the 
esb host started above would be found at
https://esb:9443/carbon.  Note that by default, the WSO2 components respond only
on https.

To login to a new component, use the carbon default uid and pwd (`admin`/`admin`),
or override the cooresponding attributes.

### WSO2 Download Files

WSO2 houses their downloads behind an authenticated URL.  To facilitate automated
installs, the downloadable files must be available to chef.  The recipe 
attempts to use downloaded files that are found in the directory
specified by `Chef::Config[:file_cache_path]`.
Files in this directory must be named according to the WSO2 standard format: `wso2<component>-<version>.zip`,
for example, `wso2emm-1.1.0.zip`.  This recipe does not support other download
formats, such as `.tar.gz`.  

For convenience, the `Vagrantfile` sets the chef cache directory to a local
directory to allow the files to be stored across instance destroys.

### Changing the Version of a Component

To update the version of a specific component, you must make the appropriate
file available and override the default version number for the given component.
For example, if you want to update the IS server to version 5.2.0, you could 
edit the `Vagrantfile` to include

```ruby
chef.json = {
  wso2: {
    is: {
      version: '5.2.0'
    }
  }
}
```

And place the `wso2is-5.2.0.zip` file in Chef's `file_cache_path`.  If you're using
the supplied `Vagrantfile`, the file would be placed in `chef_file_cache`.

### Changing the Version of the JDK

The cookbook uses the [java cookbook](https://supermarket.chef.io/cookbooks/java)
to install the JDK.  The default attributes may be overridden by setting the
appropriate values.  This recipe installs Oracle version 7, which is the current
recommended version.  Several of the components do not yet work with the version
8 JDK.  The OpenJDK is not recommended by WSO2 at present.

In the `Vagrantfile`, you could override the JDK version by setting `chef.json`
as follows:

```ruby
chef.json = {
  java: {
    install_flavor: 'oracle',
    jdk_version: '6'
  }
}
```

### Testing Recipes

The cookbook was created using `berks`, which includes `kitchen` by default.
The `.kitchen.yml` file has not been configured, so while `kitchen` commands
will work, they don't do anything useful at the moment.  

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: bhazard
