# wso2-cookbook

This cookbook provides recipes to install the following WSO2 modules:

* WSO2 Application Server (as)
* WSO2 Business Activity Monitor (bam)
* WSO2 Enterprise Mobility Manager (emm)
* WSO2 Enterprise Service Bus (esb)
* WSO2 Identity Server (is)

## Supported Platforms

Built and tested on Ubuntu 14.04.

## Attributes

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
    <td>Root path for installing the wso2comp-version directory.  Usually /opt or <code>/usr/local</code>.</td>
    <td><tt>/opt</tt></td>
  </tr>
  <tr>
    <td><tt>['wso2']['download_dir']</tt></td>
    <td>string</td>
    <td>Location of downloaded WSO2 zip files.</td>
    <td><tt>Chef::Config[:file_cache_path]</tt></td>
  </tr>
  <tr>
    <td><tt>['java']['jdk_version']</tt></td>
    <td>string</td>
    <td>Oracle JDK version.</td>
    <td><tt>7</tt></td>
  </tr>
</table>

## Usage

### wso2::component-name

Include `wso2::component-name` in your node's `run_list`.  For example, the
following will install the Business Activity Monitor ("bam"):

```json
{
  "run_list": [
    "recipe[wso2::bam]"
  ]
}
```

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
[hostmanager plugin](https://github.com/smdahlen/vagrant-hostmanager) to 
update your hosts file on both the host and guest.  To access a running vm, 
you can point your browser to `https://component:9443/carbon`.  For example, the 
esb host started above would be found at
https://esb:9443/carbon.  Note that by default, the WSO2 components respond only
on https.

To login to a new component, use the carbon default uid and pwd (`admin`/`admin`)

### WSO2 Download Files

WSO2 houses their downloads behind an authenticated URL.  To facilitate automated
installs, the downloadable files must be available to chef.  The recipe 
attempts to use downloaded files that are found in the `chef_file_cache` directory.
These must be named according to the WSO2 standard format: `wso2<component>-<version>.zip`,
for example, `wso2emm-1.1.0.zip`.  This recipe does not support other download
formats, such as `.tar.gz`.  If the required download is not found, the recipe
will attempt to download it from xxx.

For convenience, the `Vagrantfile` sets 


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: bhazard
