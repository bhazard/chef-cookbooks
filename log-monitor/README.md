# log-monitor chef cookbook

This chef cookbook provides recipes for creating centralized logging servers
based on elasticsearch, logstash and kibana.  

## Supported Platforms

Only tested on ubuntu 14.04 so far.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['logstash']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### logstash::default

Include `log-monitor::kibana` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[logstash::elasticsearch]",
    "recipe[logstash::kibana]"
  ]
}
```

## License and Authors

Author:: Bill Hazard (bhazard)
