import "date"
import "influxdata/influxdb/schema"

option task = {name: "ESL_test_bucket_downsample_1h_rfpower", cron: "20 * * * *"}

from(bucket: "test_bucket")
    |> range(start: date.truncate(t: -1h, unit: 1h), stop: date.truncate(t: now(), unit: 1h))
    |> filter(fn: (r) => r["_measurement"] == "influxdb_esl_measurement")
    |> schema.fieldsAsCols()
    |> group(columns: ["enum"])
    |> aggregateWindow(every: 1h, column: "rfpower", fn: mean, createEmpty: false)
    |> drop(columns: ["_start", "_stop"])
    |> set(key: "_measurement", value: "influxdb_esl_measurement_rfpower")
    |> to(bucket: "test_bucket-ds-1h", timeColumn: "_time", tagColumns: ["enum"], fieldFn: (r) => ({"rfpower": r.rfpower}))
