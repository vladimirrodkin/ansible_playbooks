import "date"

option task = {name: "AP_stage02_downsample_1d_count", cron: "0 23 * * *"}

from(bucket: "stage02")
    |> range(start: date.truncate(t: -24h, unit: 1h), stop: date.truncate(t: now(), unit: 1h))
    |> filter(fn: (r) => r["_measurement"] == "influxdb_ap_measurement" and r["_field"] == "mac")
    |> pivot(rowKey: ["_time"], columnKey: ["_field"], valueColumn: "_value")
    |> group(columns: ["mac"])
    |> aggregateWindow(every: 1d, column: "sn", fn: count, createEmpty: false)
    |> drop(columns: ["_start", "_stop"])
    |> set(key: "_measurement", value: "influxdb_ap_measurement_count")
    |> to(bucket: "stage02-ds-1d", timeColumn: "_time", fieldFn: (r) => ({"count": r.sn}))
