# wso2-cookbook

This cookbook provides recipes to install the following WSO2 modules:

* WSO2 Business Activity Monitor (bam)

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
    <td><tt>['wso2']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### wso2::default

Include `wso2` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[wso2::bam]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: bhazard
