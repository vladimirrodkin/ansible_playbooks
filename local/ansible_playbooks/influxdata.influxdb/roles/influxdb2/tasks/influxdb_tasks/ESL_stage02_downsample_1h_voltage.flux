import "date"
import "influxdata/influxdb/schema"

option task = {name: "ESL_stage02_downsample_1h_voltage", cron: "2 * * * *"}

from(bucket: "stage02")
    |> range(start: date.truncate(t: -1h, unit: 1h), stop: date.truncate(t: now(), unit: 1h))
    |> filter(fn: (r) => r["_measurement"] == "influxdb_esl_measurement")
    |> schema.fieldsAsCols()
    |> group(columns: ["enum"])
    |> aggregateWindow(every: 1h, column: "voltage", fn: mean, createEmpty: false)
    |> drop(columns: ["_start", "_stop"])
    |> set(key: "_measurement", value: "influxdb_esl_measurement_voltage")
    |> to(bucket: "stage02-ds-1h", timeColumn: "_time", tagColumns: ["enum"], fieldFn: (r) => ({"voltage": r.voltage}))
